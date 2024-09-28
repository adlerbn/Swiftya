import SwiftUI

/// A custom layout that arranges its subviews in a wrapping style, similar to a flow layout.
/// Subviews are arranged horizontally until they exceed the specified width, at which point they wrap onto the next line.
/// The horizontal alignment within each row can be controlled via the `alignment` parameter.
public struct WrapLayout: Layout {
    
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat
    
    /// Initializes a `WrapLayout` layout with optional alignment and spacing.
    ///
    /// - Parameters:
    ///   - alignment: The horizontal alignment of the subviews within each row. The default is centered.
    ///   - spacing: The spacing between subviews and between rows. The default is 10 points.
    public init(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat = 10
    ) {
        self.alignment = alignment
        self.spacing = spacing
    }
    
    /// Calculates the total size that fits all subviews within the specified width, wrapping rows when necessary.
    ///
    /// - Parameters:
    ///   - proposal: The proposed size from the parent view, specifying the constraints for the layout.
    ///   - subviews: The list of subviews to be arranged in this layout.
    ///   - cache: A cache for storing any calculated values that might improve performance. Not used in this layout.
    /// - Returns: The total size required to fit all the subviews, wrapping into rows as needed.
    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        var totalHeight: CGFloat = 0  // Tracks the total height of all rows
        var currentRowWidth: CGFloat = 0  // Tracks the current row's width
        var currentRowHeight: CGFloat = 0  // Tracks the current row's height
        let maxWidth = proposal.width ?? .infinity  // The maximum width allowed by the parent view
        
        // Iterate through each subview and calculate the necessary layout
        for view in subviews {
            let viewSize = view.sizeThatFits(.unspecified)  // Measure the size of each subview
            
            // Check if adding this subview exceeds the maximum width for the current row
            if currentRowWidth + viewSize.width + spacing > maxWidth {
                // Move to the next row
                totalHeight += currentRowHeight + spacing  // Add the row height and spacing
                currentRowWidth = viewSize.width + spacing  // Start a new row
                currentRowHeight = viewSize.height  // Reset the row height to the current subview's height
            } else {
                // Add the subview to the current row
                currentRowWidth += viewSize.width + spacing
                currentRowHeight = max(currentRowHeight, viewSize.height)  // Update the row height if necessary
            }
        }
        
        // Add the height of the last row
        totalHeight += currentRowHeight
        
        // Return the total width and height required to display all subviews
        return CGSize(width: maxWidth, height: totalHeight)
    }
    
    /// Places the subviews within the specified bounds, arranging them in a wrapping manner.
    ///
    /// - Parameters:
    ///   - bounds: The rectangle in which the layout will be placed.
    ///   - proposal: The proposed size from the parent view.
    ///   - subviews: The list of subviews to be arranged in this layout.
    ///   - cache: A cache for storing any calculated values that might improve performance. Not used in this layout.
    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var origin = CGPoint(x: bounds.minX, y: bounds.minY)  // Starting point for placing subviews
        let maxWidth = bounds.width  // The maximum allowed width within the bounds
        
        var currentRow: [LayoutSubviews.Element] = []  // Holds the subviews in the current row
        var currentRowWidth: CGFloat = 0  // Tracks the width of the current row
        var currentRowHeight: CGFloat = 0  // Tracks the height of the current row
        
        // Iterate through each subview and arrange them into rows
        for view in subviews {
            let viewSize = view.sizeThatFits(.unspecified)
            
            // If adding this subview exceeds the max width, place the current row and move to the next
            if currentRowWidth + viewSize.width + spacing > maxWidth {
                // Place the current row in the calculated position
                placeRow(currentRow, in: CGRect(x: bounds.minX, y: origin.y, width: maxWidth, height: currentRowHeight), currentRowWidth: currentRowWidth)
                
                // Move to the next row
                origin.y += currentRowHeight + spacing  // Update the origin for the next row
                currentRow = [view]  // Start a new row with the current subview
                currentRowWidth = viewSize.width + spacing  // Set the current row width
                currentRowHeight = viewSize.height  // Set the row height to this subview's height
            } else {
                // Add subview to the current row
                currentRow.append(view)
                currentRowWidth += viewSize.width + spacing
                currentRowHeight = max(currentRowHeight, viewSize.height)  // Update row height if needed
            }
        }
        
        // Place the last row, if there are any remaining subviews
        if !currentRow.isEmpty {
            placeRow(currentRow, in: CGRect(x: bounds.minX, y: origin.y, width: maxWidth, height: currentRowHeight), currentRowWidth: currentRowWidth)
        }
    }
    
    /// Helper function to place all views in a single row within the provided bounds.
    ///
    /// - Parameters:
    ///   - row: The array of subviews to be placed in the row.
    ///   - bounds: The rectangle in which to place the subviews.
    ///   - currentRowWidth: The total width of the current row, used to adjust the horizontal alignment.
    private func placeRow(
        _ row: [LayoutSubviews.Element],
        in bounds: CGRect,
        currentRowWidth: CGFloat
    ) {
        // Adjust the x starting point based on the specified alignment
        var x: CGFloat
        switch alignment {
        case .leading:
            x = bounds.minX  // Align left
        case .center:
            x = bounds.minX + (bounds.width - currentRowWidth) / 2  // Center align
        case .trailing:
            x = bounds.maxX - currentRowWidth  // Align right
        default:
            x = bounds.minX
        }
        
        // Iterate through the subviews in the row and place them one after the other
        for view in row {
            let viewSize = view.sizeThatFits(.unspecified)
            view.place(at: CGPoint(x: x, y: bounds.minY), proposal: .unspecified)
            x += viewSize.width + spacing  // Update the x position for the next subview
        }
    }
}


#Preview {
    WrapLayout {
        ForEach(0..<10) { _ in
            let width = CGFloat.random(in: 10...100)
            let height = CGFloat.random(in: 10...100)
            
            RoundedRectangle(cornerRadius: 10)
                .frame(
                    width: width,
                    height: height
                )
        }
    }
}
