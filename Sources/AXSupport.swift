import AppKit
import ApplicationServices
import Foundation

extension String: @retroactive Error {}

enum AXSupport {
    static func isTrusted(prompt: Bool) -> Bool {
        _ = prompt
        return AXIsProcessTrustedWithOptions(
            [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): false] as CFDictionary
        )
    }

    static func openAccessibilitySettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") else {
            return
        }
        NSWorkspace.shared.open(url)
    }

    static func relaunch() {
        let path = Bundle.main.bundlePath
        let escaped = "'" + path.replacingOccurrences(of: "'", with: "'\\''") + "'"
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/bin/zsh")
        proc.arguments = ["-c", "sleep 0.4; /usr/bin/open \(escaped)"]
        try? proc.run()
        NSApp.terminate(nil)
    }

    static func selectedText() -> Result<String, String> {
        guard isTrusted(prompt: false) else {
            return .failure("Accessibility is required to read the frontmost selection.")
        }

        let selfBundle = Bundle.main.bundleIdentifier
        let front = NSWorkspace.shared.frontmostApplication
        let foreign: NSRunningApplication? = {
            if let front, front.bundleIdentifier != selfBundle {
                return front
            }
            return nil
        }()

        guard let pid = foreign?.processIdentifier, pid > 0 else {
            return .failure("No target application.")
        }

        let appEl = AXUIElementCreateApplication(pid)
        var focusedRef: CFTypeRef?
        let focusedStatus = AXUIElementCopyAttributeValue(
            appEl,
            kAXFocusedUIElementAttribute as CFString,
            &focusedRef
        )

        var focused: AXUIElement?
        if focusedStatus == .success, let focusedRef {
            focused = asElement(focusedRef)
        }

        if focused == nil {
            var systemFocused: CFTypeRef?
            let systemWide = AXUIElementCreateSystemWide()
            if AXUIElementCopyAttributeValue(
                systemWide,
                kAXFocusedUIElementAttribute as CFString,
                &systemFocused
            ) == .success, let systemFocused {
                focused = asElement(systemFocused)
            }
        }

        guard let element = focused else {
            return .failure(axMessage(focusedStatus, fallback: "No focused element."))
        }

        var selection = copyString(element, kAXSelectedTextAttribute as CFString) ?? ""
        if selection.isEmpty {
            let value = copyString(element, kAXValueAttribute as CFString) ?? ""
            if value.count > 8000 {
                selection = String(value.prefix(8000))
            } else {
                selection = value
            }
        }

        return .success(selection)
    }

    private static func copyString(_ element: AXUIElement, _ attribute: CFString) -> String? {
        var ref: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute, &ref) == .success else { return nil }
        return ref as? String
    }

    private static func axMessage(_ error: AXError, fallback: String) -> String {
        if error == .success { return fallback }
        return "Accessibility error (\(error.rawValue)). \(fallback)"
    }

    private static func asElement(_ value: CFTypeRef) -> AXUIElement? {
        guard CFGetTypeID(value) == AXUIElementGetTypeID() else { return nil }
        return unsafeBitCast(value, to: AXUIElement.self)
    }
}
