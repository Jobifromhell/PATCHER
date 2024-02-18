//import SwiftUI
//import AppKit
//
//extension StageViewModel {
//    // Method to capture and save stage plot
//    func captureAndSaveStagePlot() {
//        DispatchQueue.main.async {
//            let stagePlotView = StagePlotView(viewModel: self) // Ensure 'self' is the correct reference
//            let hostingView = NSHostingView(rootView: stagePlotView)
//            
//            // Explicitly set the frame size to ensure the hosting view has a defined size
//            let targetSize = CGSize(width: 1600, height: 1200)
//            hostingView.frame = CGRect(origin: .zero, size: targetSize)
//
//            // Use layoutSubtreeIfNeeded to ensure the view layout is updated
//            hostingView.layoutSubtreeIfNeeded()
//
//            // Now proceed to capture the view content
//            let image = NSImage(size: targetSize)
//            image.lockFocus()
//            if let context = NSGraphicsContext.current?.cgContext {
//                hostingView.layer?.render(in: context)
//            }
//            image.unlockFocus()
//
//            // Proceed with saving or handling the image as needed
//            self.saveImage(image)
//        }
//    }
//
//    // Method to save stage elements to URL
//    func saveStageElements(_ elements: [StageElement], to url: URL) {
//        do {
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(elements)
//            try data.write(to: url)
//            print("Éléments de la scène sauvegardés avec succès : \(elements.count) éléments.")
//        } catch {
//            print("Erreur lors de la sauvegarde des éléments de la scène : \(error)")
//        }
//    }
//
//    // Method to load stage elements from URL
//    func loadStageElements(from url: URL) -> [StageElement]? {
//        do {
//            let data = try Data(contentsOf: url)
//            let decoder = JSONDecoder()
//            let elements = try decoder.decode([StageElement].self, from: data)
//            return elements
//        } catch {
//            print("Failed to load stage elements: \(error)")
//            return nil
//        }
//    }
//
//
//    // Private method to save NSImage
//    private func saveImage(_ image: NSImage) {
//        // Add code for saving NSImage here
//    }
//
//    // Method to capture NSView as NSImage
//    func captureView() -> NSImage {
//        let controller = NSHostingController(rootView: StagePlotView(viewModel: self))
//        let size = controller.view.intrinsicContentSize
//        controller.view.bounds = CGRect(origin: .zero, size: size)
//        controller.view.wantsLayer = false
//        controller.view.layer?.backgroundColor = NSColor.clear.cgColor
//        let image = NSImage(size: size)
//        image.lockFocus()
//        defer { image.unlockFocus() }
//        controller.view.draw(controller.view.bounds)
//        return image
//    }
//}
