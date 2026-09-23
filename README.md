<div align="center">

# Homoglyph Inspector

**Inspect clipboard text for lookalike letters, zero-width characters, and bidi overrides. Copy cleaned writes the stripped string.**

Menu extra for macOS 14+. Lives on the **right** of the menu bar. No Dock icon.

<br/>

[![Build](https://github.com/BadryansahBangsawan/homoglyph-inspector/actions/workflows/ci.yml/badge.svg)](https://github.com/BadryansahBangsawan/homoglyph-inspector/actions/workflows/ci.yml)
[![Latest Release](https://img.shields.io/github/v/release/BadryansahBangsawan/homoglyph-inspector?style=flat-square)](https://github.com/BadryansahBangsawan/homoglyph-inspector/releases/latest)
[![macOS](https://img.shields.io/badge/macOS-14%2B-black?style=flat-square&logo=apple)](https://github.com/BadryansahBangsawan/homoglyph-inspector/releases/latest)

<br/>

| | |
|---|---|
| Product | `HomoglyphInspector` |
| Bundle ID | `engineer.badry.homoglyphinspector` |
| Cask | `homoglyph-inspector` |
| Status item | SF Symbol `text.viewfinder` |
| Panel | opaque ~360×420 pt |

</div>

---

## What you get

| Piece | Behavior |
|---|---|
| **Clipboard** | Watches text changes. Paste field inspects without copying. |
| **Findings** | Kind labels: Zero-width / invisible, Bidirectional override, Non-breaking space, Fullwidth Latin, Looks like Latin. Cap 50,000 Unicode scalars (**Inspecting first 50000 characters.**). |
| **Copy cleaned** | Homoglyphs replaced, hidden characters stripped. |
| **Copy code point** | A finding’s `U+XXXX` hex. |
| **Inspect selection** | Frontmost selection via Accessibility (optional). |
| **Login** | Open at Login from Settings (`SMAppService`). |

---

## Download

| File | Use |
|---|---|
| **`HomoglyphInspector.app.zip`** | Homebrew cask / unzip, drag **HomoglyphInspector** onto **Applications** |

**[Releases](https://github.com/BadryansahBangsawan/homoglyph-inspector/releases/latest)**

---

## Install

### Homebrew

```bash
brew tap BadryansahBangsawan/mac-menu-apps
brew trust BadryansahBangsawan/mac-menu-apps
brew install --cask homoglyph-inspector
```

`brew trust` is required on Homebrew 6 or `brew install --cask` refuses the tap.

First open (ad-hoc signed):

```bash
xattr -cr /Applications/HomoglyphInspector.app
open /Applications/HomoglyphInspector.app
```

Still blocked: System Settings → Privacy & Security → Open Anyway.

Do not run `dist/HomoglyphInspector.app` while `/Applications/HomoglyphInspector.app` is running (same bundle ID).

---

## How to open

This is an `LSUIElement` extra. Proof it is running is the **text.viewfinder** status item on the **right** of the menu bar, not a window from Finder or Launchpad.

1. Click that extra. The panel is opaque ~360×420 pt, not a 10px strip.
2. If the bar is full, look behind the Control Center overflow chevron **«**.
3. Double-clicking in Finder/Launchpad only changes the left-side app name. That is expected. There is no Dock icon.

---

## Usage

1. Copy text, or paste below the hint *Copy text, or paste below.*
2. Findings list lookalikes and hidden characters. Empty: **No homoglyphs or hidden characters.** Cap: **Inspecting first 50000 characters.**
3. **Copy cleaned** / **Inspect selection**. **Copy code point** copies `U+XXXX`.
4. If Accessibility is untrusted, use the Inspect selection CTA, then **Relaunch** if the switch was already on.
5. **Settings** at the bottom: Open at Login, Quit.

---

## Permissions

Accessibility is optional and used only for **Inspect selection**. Deny shows **Accessibility is required to read the frontmost selection.** Clipboard inspect works without it.

Ad-hoc `codesign -s -` binds Accessibility to a **cdhash**. Reinstall is a new identity.

1. Privacy & Security → Accessibility: toggle **off**, then **on** for Homoglyph Inspector.
2. Click **Relaunch**. macOS does not grant that right to a process that is already running.

---

## Data

Nothing is persisted except Open at Login via `SMAppService`. Clipboard is read live. No Application Support folder.

---

## Privacy

No network. Inspected text never leaves this Mac.

---

## Uninstall

```bash
brew uninstall --cask homoglyph-inspector
```

Or delete `/Applications/HomoglyphInspector.app`.

Turn off **Homoglyph Inspector** in System Settings → General → Login Items if it remains.

---

## Troubleshooting

| What you see | What to do |
|---|---|
| Finder “opens” nothing / no Dock icon | Click the **text.viewfinder** extra on the right of the menu bar. |
| Extra missing | Overflow **«**, or `pgrep -x HomoglyphInspector` then `open /Applications/HomoglyphInspector.app`. |
| “Damaged” / cannot verify | `xattr -cr /Applications/HomoglyphInspector.app`. `spctl --assess` is `rejected` even when it runs. |
| `brew install --cask` refuses the tap | `brew trust BadryansahBangsawan/mac-menu-apps` |
| **Accessibility is required to read the frontmost selection.** | Toggle off/on, then **Relaunch** (cdhash). Clipboard inspect still works. |
| **No selected text.** | Focus a field with a selection, then **Inspect selection**. |
| No findings | Text has no homoglyphs or hidden chars. Intended. |
| ~10px empty strip under the bar | Reinstall from this repo. |

---

## Build from source

```bash
git clone https://github.com/BadryansahBangsawan/homoglyph-inspector.git
cd homoglyph-inspector
swift build -c release --product HomoglyphInspector
bash package-app.sh
open dist/HomoglyphInspector.app
```

Tag `v*` runs CI: `HomoglyphInspector.app.zip`. Never commit `dist/`.

Layout: `Sources/` (SwiftPM executable), `Info.plist`, `Assets/AppIcon.icns`, `package-app.sh`. `FunTheme.swift` is copied verbatim (no shared package).

---

## FAQ

**Why is there no Dock icon?**  
It is a menu extra. Click the text.viewfinder item on the **right** of the menu bar.

**Do I need Accessibility?**  
Only for **Inspect selection**. Clipboard inspect works without it.

**Where is the text stored?**  
Nowhere. Clipboard is read live. Nothing under Application Support.

**How do I stop it opening at login?**  
Settings in the panel, or System Settings → General → Login Items → **Homoglyph Inspector**.

---

<div align="center">

[MIT](LICENSE)

</div>
