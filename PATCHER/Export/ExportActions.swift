////
////  ExportActions.swift
////  PATCHER
////
////  Created by Olivier Jobin on 18/02/2024.
////
//import SwiftUI
//import Foundation
//import AppKit
//
//extension ExportView {
//    func saveProjectChanges() {
//        // Vérifiez d'abord si vous pouvez obtenir l'index du projet actuel
//        if let projectIndex = projectManager.savedProjects.firstIndex(where: { $0.id == currentProject?.id }) {
//            // Ensuite, faites une copie du projet que vous pouvez modifier
//            var projectToUpdate = projectManager.savedProjects[projectIndex]
//
//            // Appliquez vos mises à jour à cette copie
//            projectToUpdate.audioPatches = self.audioPatches
//            projectToUpdate.outputPatches = self.outputPatches
//            projectToUpdate.stageElements = self.stageViewModel.stageElements
//
//            // Réassignez la copie mise à jour au tableau original
//            projectManager.savedProjects[projectIndex] = projectToUpdate
//
//            // Log pour confirmer les mises à jour
//            print("Projet \(projectToUpdate.projectName) sauvegardé avec \(projectToUpdate.stageElements.count) éléments de scène.")
//
//            // Persistez les modifications
//            projectManager.saveProjectsToUserDefaults()
//        } else {
//            // Gérez le cas où le projet actuel n'est pas trouvé dans le tableau
//            print("Projet actuel non trouvé dans la liste des projets sauvegardés.")
//        }
//    }
//    func drawStageElement(_ element: StageElement, in image: NSImage, size: CGSize) {
//        let position = CGPoint(x: element.positionXPercent * size.width, y: element.positionYPercent * size.height)
//        let color = getColor(for: element.type) // Assurez-vous que cette méthode retourne NSColor
//        let path = NSBezierPath() // Utilisez la forme appropriée en fonction du type d'élément
//        
//        // Exemple de dessin d'un élément carré
//        let elementSize: CGFloat = 50 // Taille de l'élément, à ajuster selon le type
//        let rect = CGRect(x: position.x - elementSize / 2, y: position.y - elementSize / 2, width: elementSize, height: elementSize)
//        path.appendRect(rect)
//        
//        color.setFill()
//        path.fill()
//    }
//    
//    func getColor(for type: ElementType) -> NSColor {
//        switch type {
//            // Exemple de couleurs pour différents types, ajustez selon vos besoins
//        case .riser2x2, .riser3x2, .riser2x1, .riser4x3 /*.amplifier, .keys*/:
//            return NSColor.gray
//        case .powerOutlet, .patchBox:
//            return NSColor.orange
//        case .source, .musician:
//            return NSColor.black
//        case .wedge:
//            return NSColor.green
//        case .iem:
//            return NSColor.blue
//        }
//    }
//    
//    
//    func drawProjectName(on image: NSImage, projectName: String, in size: CGSize) {
//        let attrs: [NSAttributedString.Key: Any] = [
//            .font: NSFont.systemFont(ofSize: 20),
//            .foregroundColor: NSColor.black
//        ]
//        
//        let string = NSString(string: projectName)
//        let stringSize = string.size(withAttributes: attrs)
//        let stringRect = CGRect(x: (size.width - stringSize.width) / 2, y: size.height - stringSize.height - 20, width: stringSize.width, height: stringSize.height)
//        string.draw(in: stringRect, withAttributes: attrs)
//    }
//    func renderViewToImage<T: View>(_ view: T, size: CGSize) -> NSImage {
//        let hostingView = NSHostingView(rootView: view)
//        hostingView.frame = CGRect(origin: .zero, size: size)
//        hostingView.wantsLayer = true
//        
//        let image = NSImage(size: size)
//        image.lockFocus()
//        
//        // Dessiner un fond blanc avec CGContext
//        if let context = NSGraphicsContext.current?.cgContext {
//            context.setFillColor(NSColor.white.cgColor)
//            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
//            
//            let attributes = [
//                NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12),
//                NSAttributedString.Key.foregroundColor: NSColor.black
//            ]
//            var yOffset = size.height - 20 // Commencez par le haut de l'image et ajustez selon vos besoins
//            
//            for patch in audioPatches {
//                let string = "Location: \(patch.location), Patch No: \(patch.patchNumber), Source: \(patch.source), Mic/DI: \(patch.micDI), Stand: \(patch.stand), Phantom: \(patch.phantom ? "Yes" : "No")"
//                let attrString = NSAttributedString(string: string, attributes: attributes)
//                attrString.draw(at: CGPoint(x: 10, y: yOffset))
//                yOffset -= 20 // Ajustez cette valeur pour espacer les lignes
//            }
//        }
//        image.unlockFocus()
//        return image
//    }
//    //    func createPDF(from image: NSImage) -> Data? {
//    //        let pdfData = NSMutableData()
//    //        let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
//    //        var mediaBox = CGRect(origin: .zero, size: image.size)
//    //        guard let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil) else { return nil }
//    //
//    //        pdfContext.beginPDFPage(nil)
//    //        // Définir un fond blanc
//    //        pdfContext.setFillColor(CGColor.white)
//    //        pdfContext.fill(mediaBox)
//    //        // Dessiner l'image
//    //        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
//    //        pdfContext.draw(cgImage, in: mediaBox)
//    //        pdfContext.endPDFPage()
//    //        pdfContext.closePDF()
//    //
//    //        return pdfData as Data
//    //    }
//    //    func saveImageWithPanel(pdfImage: NSImage) {
//    //        let savePanel = NSSavePanel()
//    //        savePanel.allowedFileTypes = ["png"]
//    //        savePanel.canCreateDirectories = true
//    //        savePanel.showsTagField = false
//    //        savePanel.title = "Save Image"
//    //        savePanel.message = "Choose a location to save the image."
//    //        savePanel.nameFieldStringValue = "ExportedImage.png"
//    //        savePanel.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first
//    //
//    //        savePanel.begin { response in
//    //            if response == .OK, let url = savePanel.url {
//    //                do {
//    //                    guard let tiffData = pdfImage.tiffRepresentation,
//    //                          let bitmapImage = NSBitmapImageRep(data: tiffData),
//    //                          let pngData = bitmapImage.representation(using: .png, properties: [:]) else { return }
//    //
//    //                    try pngData.write(to: url)
//    //                    print("Image saved at: \(url.path)")
//    //                } catch {
//    //                    print("Error saving image: \(error)")
//    //                }
//    //            }
//    //        }
//    //    }
//    //    func showSavePanel() {
//    //        let savePanel = NSSavePanel()
//    //        savePanel.allowedFileTypes = ["png"]
//    //        savePanel.canCreateDirectories = true
//    //        savePanel.showsTagField = false
//    //        savePanel.title = "Sauvegarder l'image"
//    //        savePanel.message = "Choisissez l'emplacement pour sauvegarder l'image."
//    //        savePanel.nameFieldStringValue = "ImageExportée.png"
//    //        savePanel.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first
//    //
//    //        savePanel.begin { response in
//    //            if response == .OK, let url = savePanel.url {
//    //                // Ici, vous sauvegardez vos données à l'URL sélectionnée
//    //                // Par exemple, sauvegarder une image
//    //                //                saveImageToDisk(image: renderViewToImage(), at: url)
//    //            }
//    //        }
//    //    }
//}
////struct PDFViewer: NSViewRepresentable {
////    var pdfDocument: PDFDocument
////
////    func makeNSView(context: Context) -> PDFView {
////        let pdfView = PDFView()
////        pdfView.document = pdfDocument
////        pdfView.autoScales = true
////        return pdfView
////    }
////    func updateNSView(_ nsView: PDFView, context: Context) {}
////}
//struct ExportView_Previews: PreviewProvider {
//    @State static var sampleProject: Project? = nil
//    @StateObject var stageViewModel = StageViewModel()
//    static var previews: some View {
//        
//        let previewViewModel = StageViewModel()
//        return ExportView(
//            audioPatches: [],
//            outputPatches: [],
//            stageElements: [],
//            currentProject: $sampleProject,
//            stageViewModel: previewViewModel // Pass the instance here
//        )
//        .environmentObject(ProjectManager.shared)
//        .environmentObject(SharedData())
//    }
//}
//
//
//extension NSImage {
//    func asImage() -> Image {
//        Image(nsImage: self)
//    }
//}
//
