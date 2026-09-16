import AppKit
import SwiftUI

struct RootView: View {
    @EnvironmentObject private var store: InspectorStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: FunTheme.sectionSpacing) {
            Text("Homoglyph Inspector")
                .font(.headline)

            if store.text.isEmpty {
                Text("Copy text, or paste below.")
                    .foregroundStyle(.secondary)
            }

            TextEditor(text: $store.text)
                .font(.system(.body, design: .monospaced))
                .frame(minHeight: 72)
                .onChange(of: store.text) {
                    store.rescan()
                }
                .extraRowSurface()

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
                    VStack(alignment: .leading, spacing: FunTheme.innerSpacing) {
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
            .buttonStyle(.borderedProminent)

            Button("Inspect selection") {
                store.inspectSelection()
            }
            .buttonStyle(.bordered)

            if let axError = store.axError {
                Label(axError, systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if !store.axTrusted {
                VStack(alignment: .leading, spacing: FunTheme.innerSpacing) {
                    Text("If the switch is already on, turn it off and on, then Relaunch.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    HStack {
                        Button("Open Accessibility Settings") {
                            AXSupport.openAccessibilitySettings()
                            store.axTrusted = AXSupport.isTrusted(prompt: false)
                        }
                        Button("Relaunch") {
                            AXSupport.relaunch()
                        }
                    }
                }
            }

            ExtraSettingsFooter()
        }
        .animation(reduceMotion ? nil : FunTheme.spring, value: store.findings)
        .animation(reduceMotion ? nil : FunTheme.spring, value: store.text.isEmpty)
        .funPanel()
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
        .extraRowSurface()
    }
}

private func copyToPasteboard(_ string: String) {
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(string, forType: .string)
}
