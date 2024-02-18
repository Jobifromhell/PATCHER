import SwiftUI

// Définition d'une structure qui peut capturer une vue SwiftUI dans une image NSImage
struct CaptureView<RootView: View>: NSViewRepresentable {
    let rootView: RootView
    @Binding var capturedImage: NSImage?
    @EnvironmentObject var sharedViewModel: SharedViewModel
    func makeNSView(context: Context) -> NSHostingView<RootView> {
        return NSHostingView(rootView: rootView)
    }
    
    func updateNSView(_ nsView: NSHostingView<RootView>, context: Context) {
        // Mise à jour de la vue, si nécessaire
    }
    
    static func capture(from nsView: NSView) -> NSImage? {
        print("Attempting to capture view with size: \(nsView.bounds.size)")
        guard let rep = nsView.bitmapImageRepForCachingDisplay(in: nsView.bounds) else {
            print("Failed to create bitmap image representation")
            return nil
        }
        nsView.cacheDisplay(in: nsView.bounds, to: rep)
        let image = NSImage(size: nsView.bounds.size)
        image.addRepresentation(rep)
        return image
    }



}
