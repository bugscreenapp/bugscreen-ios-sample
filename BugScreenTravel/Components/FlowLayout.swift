import SwiftUI

/// A simple wrapping layout (left-to-right, top-to-bottom) — the SwiftUI equivalent of Compose's
/// `FlowRow`, used for the destination "Highlights" chips.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        return arrange(subviews: subviews, maxWidth: maxWidth).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let result = arrange(subviews: subviews, maxWidth: bounds.width)
        for (index, subview) in subviews.enumerated() {
            let origin = result.origins[index]
            subview.place(
                at: CGPoint(x: bounds.minX + origin.x, y: bounds.minY + origin.y),
                proposal: .unspecified
            )
        }
    }

    private struct Arrangement {
        var size: CGSize
        var origins: [CGPoint]
    }

    private func arrange(subviews: Subviews, maxWidth: CGFloat) -> Arrangement {
        var origins: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var widestRow: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > 0, x + size.width > maxWidth {
                // Wrap to the next row.
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            origins.append(CGPoint(x: x, y: y))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            widestRow = max(widestRow, x - spacing)
        }

        return Arrangement(size: CGSize(width: widestRow, height: y + rowHeight), origins: origins)
    }
}
