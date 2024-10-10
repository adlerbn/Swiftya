import SwiftUI

/// A layout that arranges subviews in a masonry grid pattern with multiple columns and dynamic row heights.
/// Each subview is placed in the shortest column available, creating a Pinterest-like masonry effect.
public struct MasonryLayout: Layout {

    /// The number of columns in the layout.
    private let columns: Int

    /// The spacing between the subviews and between the columns.
    private let spacing: CGFloat

    /// Initializes the layout with a given number of columns and spacing.
    ///
    /// - Parameters:
    ///   - columns: The number of columns in the layout. Default is 3.
    ///   - spacing: The spacing between subviews. Default is 10.
    public init(
        columns: Int     = 3,
        spacing: CGFloat = 10
    ) {
        self.columns = columns
        self.spacing = spacing
    }

    /// Calculates the size that best fits all the subviews given a proposed size.
    ///
    /// - Parameters:
    ///   - proposal: The proposed size from the parent view.
    ///   - subviews: The array of subviews in the layout.
    ///   - cache: A placeholder cache for internal use. In this case, it's unused.
    /// - Returns: The total size required to fit all subviews.
    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        // Get the available width from the proposal
        let width = proposal.replacingUnspecifiedDimensions().width
        // Calculate the frames for all subviews based on the available width
        let viewFrames = frames(for: subviews, in: width)
        // Get the maximum Y value from the subview frames to determine the required height
        let height = viewFrames.max { $0.maxY < $1.maxY } ?? .zero
        
        // Return the total size that fits all subviews
        return CGSize(width: width, height: height.maxY)
    }

    /// Places the subviews within the given bounds.
    ///
    /// - Parameters:
    ///   - bounds: The rectangular area to place the subviews within.
    ///   - proposal: The proposed size from the parent view.
    ///   - subviews: The array of subviews to be placed.
    ///   - cache: A placeholder cache for internal use. In this case, it's unused.
    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        // Calculate the frames for all subviews based on the bounds width
        let viewFrames = frames(for: subviews, in: bounds.width)

        // Place each subview at its calculated position
        for index in subviews.indices {
            let frame = viewFrames[index]
            let position = CGPoint(
                x: bounds.minX + frame.minX,
                y: bounds.minY + frame.minY
            )
            // Place the subview with the proposed size derived from the frame
            subviews[index].place(at: position, proposal: ProposedViewSize(frame.size))
        }
    }

    /// Calculates the frames for each subview in a masonry grid layout.
    ///
    /// - Parameters:
    ///   - subViews: The array of subviews to be laid out.
    ///   - totalWidth: The total available width for the layout.
    /// - Returns: An array of CGRect values representing the frame for each subview.
    private func frames(
        for subViews: Subviews,
        in totalWidth: Double
    ) -> [CGRect] {
        // Calculate the total spacing between columns
        let totalSpacing = Double(spacing) * Double(columns - 1)
        // Calculate the width for each column
        let columnWidth = (totalWidth - totalSpacing) / Double(columns)
        let columnWidthWithSpacing = columnWidth + Double(spacing)
        // Proposed size for each subview (based on column width, height is flexible)
        let proposedSize = ProposedViewSize(width: columnWidth, height: nil)

        var viewFrames = [CGRect]()
        // Track the cumulative height of each column
        var columnHeights = Array(repeating: 0.0, count: columns)

        // Iterate through each subview and assign it to the shortest column
        for subview in subViews {
            // Find the column with the smallest cumulative height
            var selectedColumn = 0
            var selectedHeight = Double.greatestFiniteMagnitude

            for (columnIndex, height) in columnHeights.enumerated() {
                if height < selectedHeight {
                    selectedColumn = columnIndex
                    selectedHeight = height
                }
            }

            // Calculate the x and y position for the subview
            let x = Double(selectedColumn) * columnWidthWithSpacing
            let y = columnHeights[selectedColumn]
            // Measure the subview size based on the proposed width
            let size = subview.sizeThatFits(proposedSize)
            // Create a frame for the subview
            let frame = CGRect(x: x, y: y, width: size.width, height: size.height)

            // Update the column height to account for the new subview
            columnHeights[selectedColumn] += size.height + Double(spacing)
            // Store the frame in the list
            viewFrames.append(frame)
        }

        return viewFrames
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable
    @State var columns: Int = 3

    let colors = [
        Color.blue,
        Color.red,
        Color.green,
        Color.cyan,
        Color.yellow,
        Color.brown,
        Color.black,
        Color.teal,
        Color.orange,
        Color.mint,
    ]

    ScrollView {
        MasonryLayout(columns: columns) {
            ForEach(1..<100) { index in
                let height = CGFloat.random(in: 50...200)

                RoundedRectangle(cornerRadius: 12)
                    .fill(colors.randomElement()!.gradient.opacity(0.2))
                    .frame(height: height)
                    .overlay {
                        Text("\(index)")
                    }
            }
        }
        .padding(.horizontal)
    }
    .safeAreaInset(edge: .bottom) {
        Stepper("Columns", value: $columns.animation(), in: 1...5)
            .padding()
            .background(.regularMaterial)
    }
}
