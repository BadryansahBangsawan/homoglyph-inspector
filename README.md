# Homoglyph Inspector

Inspect clipboard and selections for lookalike letters, zero-width characters, and bidi overrides.

Menu extra for macOS 14+. It lives in the menu bar and does not show a Dock icon.

## Features

- Watches the clipboard for text changes.
- Paste field to inspect text without copying.
- **Copy cleaned** writes a version with homoglyphs replaced and hidden characters stripped.
- **Copy code point** copies a finding’s `U+XXXX` hex.
- **Inspect selection** reads the frontmost selection via Accessibility.
- Caps inspection at 50,000 Unicode scalars.
- No network.

## Requirements

- macOS 14 Sonoma or later
- Swift 5.9 or later
- Accessibility only for Inspect selection

## Install

```bash
git clone https://github.com/BadryansahBangsawan/homoglyph-inspector.git
cd homoglyph-inspector
bash package-app.sh
open dist/HomoglyphInspector.app
```

`package-app.sh` builds a release binary, wraps `dist/HomoglyphInspector.app`, and ad-hoc codesigns it (`codesign -s -`). Unsigned is fine for local use.

Enable **Open at Login** from Settings if you want it after reboot.

## Usage

- Copy text or paste it into the panel.
- A `раyраl.com`-style fixture (Cyrillic lookalikes plus hidden characters) should list findings.
- If Accessibility is untrusted, use the Inspect selection CTA to open System Settings.

## Permissions

- Accessibility is optional and used only for Inspect selection. Deny shows a banner, not a crash.

Denied permissions must not crash the app. You should see a banner and a button to open System Settings.

## Privacy

No network. Inspected text stays in RAM and the pasteboard; nothing is written under Application Support.

Bundle ID: `engineer.badry.homoglyphinspector`.

## Development

```bash
swift build
swift build -c release --product HomoglyphInspector
```

Layout: `Sources/` (SwiftPM executable), `Info.plist`, `Assets/AppIcon.icns`, `package-app.sh`.

## License

[MIT](LICENSE)
