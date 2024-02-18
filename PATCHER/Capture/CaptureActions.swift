////
////  CaptureActions.swift
////  PATCHER
////
////  Created by Olivier Jobin on 18/02/2024.
////
//
//import Foundation
//
//extension CaptureView {
//    private func captureCurrentView() {
//            // Création de la vue que vous souhaitez capturer.
//            // Par exemple, si vous souhaitez capturer la vue `StagePlotView`:
//            let viewToCapture = StagePlotView(viewModel: stageViewModel)
//            
//            // Convertir cette vue en NSView.
//            let nsView = NSHostingView(rootView: viewToCapture)
//            
//            // Utiliser la fonction capture de CaptureView.
//        if let image = CaptureView<StagePlotView>.capture(from: nsView) {
//                self.capturedImage = image
//            }
//        }
//    
//    private func writeImage(_ image: NSImage, to url: URL) {
//        guard let tiffData = image.tiffRepresentation,
//              let bitmapImage = NSBitmapImageRep(data: tiffData),
//              let pngData = bitmapImage.representation(using: .png, properties: [:]) else { return }
//        do {
//            try pngData.write(to: url)
//            print("Image saved to \(url.path)")
//        } catch {
//            print("Failed to save image: \(error.localizedDescription)")
//        }
//    }
//    func createAndShowPDF(/*audioPatches: [AudioPatch], outputPatches: [OutputPatch]*/) {
//        DispatchQueue.global(qos: .userInitiated).async {
//            let size = CGSize(width: 595, height: 842) // Ajustez selon le besoin
//            let image = NSImage(size: size)
//            image.lockFocus()
//            
//            // Définir un fond blanc
//            NSColor.white.set()
//            NSRect(x: 0, y: 0, width: size.width, height: size.height).fill()
//            
//            let attributes = [
//                NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12),
//                NSAttributedString.Key.foregroundColor: NSColor.black
//            ]
//            
//            var yOffset = size.height - 50 // Commencez par le haut et ajustez selon vos besoins
//            
//            // general info
//            //                let bandInfo = "Band Name: \(sharedData.bandName), Country: \(sharedData.country), Number of Musicians: \(sharedData.numberOfMusicians)"
//            
//            // Dessiner le contenu pour AudioPatch
//            for patch in audioPatches {
//                let string = "Location: \(patch.location), Patch No: \(patch.patchNumber), Source: \(patch.source), Mic/DI: \(patch.micDI), Stand: \(patch.stand), Phantom: \(patch.phantom ? "Yes" : "No")"
//                let attrString = NSAttributedString(string: string, attributes: attributes)
//                attrString.draw(at: CGPoint(x: 10, y: yOffset))
//                yOffset -= 18 // Ajustez cette valeur pour espacer les lignes
//            }
//            
//            // Ajoutez un espace entre les sections
//            yOffset -= 30
//            
//            // Dessiner le contenu pour OutputPatch
//            for patch in outputPatches {
//                let string = "Location: \(patch.location), Patch No: \(patch.patchNumber), Bus Type: \(patch.busType), Destination: \(patch.destination), Monitor Type: \(patch.monitorType), Stereo: \(patch.isStereo ? "Stereo" : "Mono")"
//                let attrString = NSAttributedString(string: string, attributes: attributes)
//                attrString.draw(at: CGPoint(x: 10, y: yOffset))
//                yOffset -= 18 // Ajustez cette valeur pour espacer les lignes
//            }
//            
//            image.unlockFocus()
//            
//            // Sauvegardez l'image sur le bureau
//            DispatchQueue.main.async {
//                let capturedImage = self.captureStagePlotView()
////                self.stagePlotImage = Image(nsImage: capturedImage)
//                let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
//                let fileURL = desktopURL.appendingPathComponent("capturedImage.png")
//                
//                if let tiffData = capturedImage.tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffData), let data = bitmapImage.representation(using: .png, properties: [:]) {
//                    do {
//                        try data.write(to: fileURL)
//                        print("Image saved to \(fileURL.path)")
//                    } catch {
//                        print("Failed to save image: \(error)")
//                    }
//                }
//                
//                let savePanel = NSSavePanel()
//                savePanel.allowedContentTypes = [.png]
//                savePanel.canCreateDirectories = true
//                savePanel.showsTagField = false
//                savePanel.title = "Save Exported Image"
//                savePanel.message = "Choose a location to save the exported image."
//                savePanel.nameFieldStringValue = "ExportedImage.png"
//                savePanel.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first
//                
//                savePanel.begin { response in
//                    if response == .OK, let url = savePanel.url {
//                        do {
//                            guard let tiffData = image.tiffRepresentation,
//                                  let bitmapImage = NSBitmapImageRep(data: tiffData),
//                                  let pngData = bitmapImage.representation(using: .png, properties: [:]) else { return }
//                            
//                            try pngData.write(to: url)
//                            print("Image saved at: \(url.path)")
//                        } catch {
//                            print("Error saving image: \(error)")
//                        }
//                    }
//                }
//            }
//        }
//    }
//    func captureStagePlotView() -> NSImage {
//        let targetSize = CGSize(width: 1600, height: 1200) // Taille cible pour l'image capturée
//        let image = NSImage(size: targetSize)
//        
//        image.lockFocus()
//        
//        // Fond de l'image
//        NSColor.white.setFill()
//        NSBezierPath(rect: NSRect(origin: .zero, size: targetSize)).fill()
//        
//        // Dessiner chaque élément de la scène
//        for element in stageElements {
//            drawStageElement(element, in: image, size: targetSize)
//        }
//        image.unlockFocus()
//        return image
//    }
//    
//}
