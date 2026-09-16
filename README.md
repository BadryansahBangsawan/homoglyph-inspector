<div align="center">

# Homoglyph Inspector

**Spot lookalike letters, zero-width characters, and bidi overrides in any text.**  
macOS menu extra — lives in the menu bar, no Dock icon.

<br/>

[![Latest Release](https://img.shields.io/github/v/release/BadryansahBangsawan/homoglyph-inspector?style=flat-square&color=76B900&label=latest)](https://github.com/BadryansahBangsawan/homoglyph-inspector/releases/latest)
[![macOS](https://img.shields.io/badge/macOS-14%2B-black?style=flat-square&logo=apple)](https://github.com/BadryansahBangsawan/homoglyph-inspector/releases/latest)
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-F05138?style=flat-square&logo=swift&logoColor=white)](https://swift.org)

<br/>

</div>

---

## Download

| Platform | File |
|---|---|
| **macOS** (Apple Silicon & Intel, macOS 14+) | `HomoglyphInspector-*-macos.zip` |

[Go to Releases](https://github.com/BadryansahBangsawan/homoglyph-inspector/releases/latest)

---

## Installation

### Homebrew (recommended)

```bash
brew tap BadryansahBangsawan/mac-menu-apps
brew install --cask homoglyph-inspector
```

A **Homoglyph Inspector** icon appears in the menu bar. If Gatekeeper blocks it on first launch:

```bash
xattr -cr /Applications/HomoglyphInspector.app && open /Applications/HomoglyphInspector.app
```

Or: right-click the app, Open, then Open again. Still blocked? **System Settings → Privacy & Security → Open Anyway**.

### GitHub Releases

1. Download `HomoglyphInspector-*-macos.zip` from [Releases](https://github.com/BadryansahBangsawan/homoglyph-inspector/releases/latest)
2. Unzip and drag **HomoglyphInspector** into Applications
3. On first launch, run the xattr command above if Gatekeeper blocks it

### Build from source

```bash
git clone https://github.com/BadryansahBangsawan/homoglyph-inspector.git
cd homoglyph-inspector
bash package-app.sh
open dist/HomoglyphInspector.app
```

Requires Xcode Command Line Tools and Swift 5.9+.

---

## Notes

– Watches the clipboard automatically; paste into the panel to inspect without copying.
– Accessibility permission required only for Inspect Selection.
– Caps inspection at 50,000 Unicode scalars.
– No network connection — all analysis is local.

---

<div align="center">

Made with ♥ for developers who prefer staying in the flow.

</div>

