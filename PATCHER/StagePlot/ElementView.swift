import SwiftUI

struct ElementView: View {
    @Binding var element: StageElement?
    @GestureState private var dragOffset = CGSize.zero
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @ObservedObject var viewModel: StageViewModel

    var body: some View {
        Group {
            if let element = element {
                let shape: AnyShape = getShape(for: element.type)
                let color: Color = getColor(for: element.type)
                let width: CGFloat = getWidth(for: element.type)
                let height: CGFloat = getHeight(for: element.type)

                ZStack {
                    // Draw the shape of the element
                    shape
                        .fill(color)
                        .frame(width: width, height: height)
                        .opacity(0.8)
                        .overlay(shape.stroke(Color.black, lineWidth: 2))
                        .rotationEffect(element.rotation)

                    // Overlay text to display the name and additional details
                    VStack(alignment: .center, spacing: 2) {
                        Text(element.name)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        if !element.patch.isEmpty {
                            Text(element.patch)
                                .font(.caption)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        Text(element.detail)
                            .font(.caption)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    .frame(maxWidth: .infinity) // Allow text to extend beyond the bounds
                }
                .offset(dragOffset)
                .gesture(
                    DragGesture()
                        .updating($dragOffset, body: { (value, state, _) in state = value.translation })
                        .onEnded { value in
                            // Calculate new position percentages based on drag translation
                            let newXPercent = (element.positionXPercent * viewModel.stageWidth + value.translation.width) / viewModel.stageWidth
                            let newYPercent = (element.positionYPercent * viewModel.stageHeight + value.translation.height) / viewModel.stageHeight
                            viewModel.updatePosition(of: element.id, toXPercent: newXPercent, toYPercent: newYPercent)
                        }
                )
            } else {
                EmptyView()
                    .onDisappear {
            //            viewModel.saveElementChanges(element)
            //            viewModel.updateElement(element)
                        
                    }
            }
        }
    }
}
