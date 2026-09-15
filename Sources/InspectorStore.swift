import AppKit
import Combine

@MainActor
final class InspectorStore: ObservableObject {
    @Published var text = ""
    @Published var findings: [Finding] = []
    @Published var capBanner: String?
    @Published var axError: String?
    @Published var axTrusted = false

    private var lastChangeCount = NSPasteboard.general.changeCount
    nonisolated(unsafe) private var clipboardTimer: Timer?

    init() {
        startClipboardWatch()
    }

    deinit {
        clipboardTimer?.invalidate()
    }

    func rescan() {
        let result = HomoglyphScan.scan(text)
        findings = result.findings
        capBanner = result.truncated ? "Inspecting first 50000 characters." : nil
    }

    func startClipboardWatch() {
        clipboardTimer?.invalidate()
        let timer = Timer(timeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.pollClipboard()
            }
        }
        RunLoop.main.add(timer, forMode: .common)
        clipboardTimer = timer
    }

    func inspectSelection() {
        axTrusted = AXSupport.isTrusted(prompt: false)
        switch AXSupport.selectedText() {
        case .success(let selected):
            if selected.isEmpty {
                axError = "No selected text."
            } else {
                text = selected
                rescan()
                axError = nil
            }
        case .failure(let message):
            axError = message
        }
    }

    private func pollClipboard() {
        let pasteboard = NSPasteboard.general
        let changeCount = pasteboard.changeCount
        guard changeCount != lastChangeCount else { return }
        lastChangeCount = changeCount
        let string = pasteboard.string(forType: .string)
        if let string, !string.isEmpty {
            text = string
            rescan()
        } else {
            text = ""
            findings = []
            capBanner = nil
        }
    }
}
