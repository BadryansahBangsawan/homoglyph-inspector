import AppKit
import SwiftUI

struct RootView: View {
    @EnvironmentObject private var store: InspectorStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Homoglyph Inspector")
                .font(.headline)

            if store.text.isEmpty {
                Text("Copy text, or paste below.")
            }

            TextEditor(text: $store.text)
                .font(.system(.body, design: .monospaced))
                .frame(minHeight: 72)
                .onChange(of: store.text) {
                    store.rescan()
                }

            if let capBanner = store.capBanner {
                Label(capBanner, systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if !store.text.isEmpty {
                Text("\(store.findings.count) findings")
                    .font(.headline)
            }

            if !store.text.isEmpty && store.findings.isEmpty {
                Text("No homoglyphs or hidden characters.")
            }

            if !store.findings.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(store.findings) { finding in
                            FindingRow(finding: finding)
                        }
                    }
                }
                .frame(maxHeight: 480)
            }

            Button("Copy cleaned") {
                copyToPasteboard(HomoglyphScan.cleaned(store.text))
            }

            Button("Inspect selection") {
                store.inspectSelection()
            }

            if let axError = store.axError {
                Label(axError, systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if !store.axTrusted {
                Button("Open Accessibility Settings") {
                    AXSupport.openAccessibilitySettings()
                    store.axTrusted = AXSupport.isTrusted(prompt: false)
                }
            }
        }
        .funPanel()
        .background(.regularMaterial)
        .animation(reduceMotion ? nil : FunTheme.spring, value: store.findings)
        .animation(reduceMotion ? nil : FunTheme.spring, value: store.text.isEmpty)
        .onAppear {
            store.axTrusted = AXSupport.isTrusted(prompt: false)
        }
    }
}

private struct FindingRow: View {
    let finding: Finding

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(finding.display)
                .font(.system(.body, design: .monospaced))
            Text(finding.hex)
                .font(.system(.body, design: .monospaced))
            Text(finding.kindLabel)
                .font(.system(.body, design: .monospaced))
            Button("Copy code point") {
                copyToPasteboard(finding.hex)
            }
        }
        .padding(.vertical, 6)
    }
}

private func copyToPasteboard(_ string: String) {
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(string, forType: .string)
}
