import AppKit
import SwiftUI

@main
struct HomoglyphInspectorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var store = InspectorStore()

    var body: some Scene {
        MenuBarExtra("Homoglyph Inspector", systemImage: "text.viewfinder") {
            RootView()
                .environmentObject(store)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
                .environmentObject(store)
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.accessory)
    }
}
