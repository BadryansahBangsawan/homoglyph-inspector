struct Finding: Identifiable, Equatable {
    let id: Int
    let scalarValue: UInt32
    let hex: String
    let display: String
    let kindLabel: String
    let replacement: String?
}

enum HomoglyphScan {
    static func scan(_ text: String, limit: Int = 50_000) -> (findings: [Finding], truncated: Bool) {
        let scalars = text.unicodeScalars
        let truncated = scalars.count > limit
        var findings: [Finding] = []
        var index = 0
        for scalar in scalars {
            if index >= limit { break }
            if let match = classify(scalar) {
                findings.append(
                    Finding(
                        id: findings.count,
                        scalarValue: scalar.value,
                        hex: hex(scalar.value),
                        display: match.display,
                        kindLabel: match.kindLabel,
                        replacement: match.replacement
                    )
                )
            }
            index += 1
        }
        return (findings, truncated)
    }

    static func cleaned(_ text: String) -> String {
        let limit = 50_000
        var result = String.UnicodeScalarView()
        var index = 0
        var truncated = false
        for scalar in text.unicodeScalars {
            if index >= limit {
                truncated = true
                break
            }
            if let match = classify(scalar) {
                result.append(contentsOf: match.replacement.unicodeScalars)
            } else {
                result.append(scalar)
            }
            index += 1
        }
        if truncated {
            result.append(contentsOf: text.unicodeScalars.dropFirst(limit))
        }
        return String(result)
    }

    private static func hex(_ value: UInt32) -> String {
        let digits = String(value, radix: 16, uppercase: true)
        if digits.count >= 4 {
            return "U+" + digits
        }
        return "U+" + String(repeating: "0", count: 4 - digits.count) + digits
    }

    private static func classify(_ scalar: Unicode.Scalar) -> (display: String, kindLabel: String, replacement: String)? {
        let value = scalar.value
        if let display = invisible[value] {
            return (display, "Zero-width / invisible", "")
        }
        if let display = bidi[value] {
            return (display, "Bidirectional override", "")
        }
        if let display = nonBreaking[value] {
            return (display, "Non-breaking space", " ")
        }
        if (0xFF01...0xFF5E).contains(value), let ascii = Unicode.Scalar(value - 0xFEE0) {
            return (String(scalar), "Fullwidth Latin", String(ascii))
        }
        if let latin = confusable[value] {
            return (String(scalar), "Looks like Latin '\(latin)'", String(latin))
        }
        return nil
    }

    private static let invisible: [UInt32: String] = [
        0x00AD: "SOFT HYPHEN",
        0x034F: "CGJ",
        0x061C: "ALM",
        0x180E: "MVS",
        0x200B: "ZWSP",
        0x200C: "ZWNJ",
        0x200D: "ZWJ",
        0x2060: "WJ",
        0x2061: "U+2061",
        0x2062: "U+2062",
        0x2063: "U+2063",
        0x2064: "U+2064",
        0xFEFF: "BOM",
        0x3164: "HFILL",
        0xFFA0: "HWFILL",
    ]

    private static let bidi: [UInt32: String] = [
        0x200E: "LRM",
        0x200F: "RLM",
        0x202A: "LRE",
        0x202B: "RLE",
        0x202C: "PDF",
        0x202D: "LRO",
        0x202E: "RLO",
        0x2066: "LRI",
        0x2067: "RLI",
        0x2068: "FSI",
        0x2069: "PDI",
    ]

    private static let nonBreaking: [UInt32: String] = [
        0x00A0: "NBSP",
        0x202F: "NNBSP",
        0x2007: "FIGSP",
        0x3000: "IDSP",
    ]

    private static let confusable: [UInt32: Character] = [
        0x0430: "a",
        0x0435: "e",
        0x043E: "o",
        0x0440: "p",
        0x0441: "s",
        0x0443: "y",
        0x0445: "x",
        0x0456: "i",
        0x0458: "j",
        0x0410: "A",
        0x0412: "B",
        0x0415: "E",
        0x041A: "K",
        0x041C: "M",
        0x041D: "H",
        0x041E: "O",
        0x0420: "P",
        0x0421: "S",
        0x0422: "T",
        0x0425: "X",
        0x0406: "I",
        0x03BF: "o",
        0x039F: "O",
        0x03BD: "v",
        0x03C1: "p",
        0x03C4: "t",
        0x0391: "A",
        0x0392: "B",
        0x0395: "E",
        0x0396: "Z",
        0x0397: "H",
        0x0399: "I",
        0x039A: "K",
        0x039C: "M",
        0x039D: "N",
        0x03A1: "P",
        0x03A4: "T",
        0x03A5: "Y",
        0x03A7: "X",
    ]
}
