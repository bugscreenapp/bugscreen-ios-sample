// Generates the 1024×1024 app icon: a diagonal teal→coral gradient with a white glyph.
// Run once with:  swift Scripts/make_icon.swift
// (macOS only — uses AppKit to render an SF Symbol.)

import AppKit

let size = 1024.0
let image = NSImage(size: NSSize(width: size, height: size))
image.lockFocus()

// Brand gradient: teal (#0F766E) → coral (#E05D3C), top-leading to bottom-trailing.
let teal = NSColor(srgbRed: 0x0F/255, green: 0x76/255, blue: 0x6E/255, alpha: 1)
let coral = NSColor(srgbRed: 0xE0/255, green: 0x5D/255, blue: 0x3C/255, alpha: 1)
let gradient = NSGradient(colors: [teal, coral])!
gradient.draw(in: NSRect(x: 0, y: 0, width: size, height: size), angle: -45)

// White glyph, centered.
let config = NSImage.SymbolConfiguration(pointSize: size * 0.52, weight: .semibold)
if let symbol = NSImage(systemSymbolName: "paperplane.fill", accessibilityDescription: nil)?
    .withSymbolConfiguration(config) {
    let tinted = NSImage(size: symbol.size)
    tinted.lockFocus()
    NSColor.white.set()
    let rect = NSRect(origin: .zero, size: symbol.size)
    symbol.draw(in: rect)
    rect.fill(using: .sourceAtop)
    tinted.unlockFocus()

    let gw = tinted.size.width, gh = tinted.size.height
    let origin = NSPoint(x: (size - gw) / 2, y: (size - gh) / 2 - size * 0.02)
    tinted.draw(at: origin, from: .zero, operation: .sourceOver, fraction: 0.95)
}

image.unlockFocus()

guard let tiff = image.tiffRepresentation,
      let rep = NSBitmapImageRep(data: tiff),
      let png = rep.representation(using: .png, properties: [:]) else {
    fatalError("Failed to render icon")
}

let out = URL(fileURLWithPath: "BugScreenTravel/Resources/Assets.xcassets/AppIcon.appiconset/icon-1024.png")
try! png.write(to: out)
print("Wrote \(out.path)")
