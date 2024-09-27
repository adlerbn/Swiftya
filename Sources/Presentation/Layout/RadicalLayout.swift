import SwiftUI

/// A custom layout that arranges subviews in a radial pattern.
public struct RadicalLayout: Layout {
    
    /// Initializes a `RadicalLayout` layout.
    public init() {}
    
    /// Returns the size that best fits the proposed size for the layout.
    ///
    /// - Parameters:
    ///   - proposal: The size that the layout should attempt to fit within.
    ///   - subviews: The collection of subviews to be arranged.
    ///   - cache: A mutable cache to store intermediate layout data.
    /// - Returns: The size of the layout that fits the proposed size.
    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        // Replace unspecified dimensions in the proposed size with default values.
        proposal.replacingUnspecifiedDimensions()
    }
    
    /// Places subviews within the bounds of the layout in a circular pattern.
    ///
    /// - Parameters:
    ///   - bounds: The rectangular area in which to position the subviews.
    ///   - proposal: The size that the layout should attempt to fit within.
    ///   - subviews: The collection of subviews to be arranged.
    ///   - cache: A mutable cache to store intermediate layout data.
    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        // Determine the radius of the circle based on the smaller dimension of the bounds.
        let radius = min(bounds.width, bounds.height) / 2
        
        // Calculate the angle between each subview.
        let angle = Angle.degrees(360 / Double(subviews.count)).radians
        
        // Iterate over each subview and place it in a circular pattern.
        for (index, subview) in subviews.enumerated() {
            // Get the size that best fits the subview.
            let viewSize = subview.sizeThatFits(.unspecified)
            
            // Calculate the x and y positions for the subview.
            let xPosition = cos(angle * Double(index) - .pi / 2) * (radius - viewSize.width / 2)
            let yPosition = sin(angle * Double(index) - .pi / 2) * (radius - viewSize.height / 2)
            
            // Create the CGPoint representing the subview's position.
            let point = CGPoint(
                x: bounds.midX + xPosition,
                y: bounds.midY + yPosition
            )
            
            // Place the subview at the calculated position with its center anchored.
            subview.place(
                at: point,
                anchor: .center,
                proposal: .unspecified
            )
        }
    }
}

#Preview {
    RadicalLayout {
        ForEach(0..<10) { _ in
            let width = CGFloat.random(in: 10...100)
            let height = CGFloat.random(in: 10...100)
            
            Circle()
                .frame(
                    width: width,
                    height: height
                )
        }
    }
}
