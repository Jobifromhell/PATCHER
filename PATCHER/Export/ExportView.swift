import SwiftUI
import PDFKit
import AppKit
import UniformTypeIdentifiers

struct ExportView: View {
    var audioPatches: [AudioPatch]
    var outputPatches: [OutputPatch]
    var stageElements: [StageElement]
//    @State private var showingPDF = false
//    @State private var pdfDocument: PDFDocument?
    @Binding var currentProject: Project?
    @State private var capturedImage: NSImage?
    @EnvironmentObject var projectManager: ProjectManager
//    @EnvironmentObject var sharedData: SharedData
    @ObservedObject var stageViewModel: StageViewModel
    @State private var lastLoadedProjectId: UUID?
    @EnvironmentObject var sharedViewModel: SharedViewModel
    
//    @State private var stagePlotImage: Image? = nil
//    @State private var capturedImagePath: URL? = nil // Ajout de la variable pour stocker le chemin de l'image capturée
//    @State private var capturedStagePlotImage: NSImage? = nil
// Ensure you have an initializer that accepts stageViewModel

//    init(audioPatches: [AudioPatch], outputPatches: [OutputPatch], stageElements: [StageElement], currentProject: Binding<Project?>, stageViewModel: StageViewModel) {
//        self.audioPatches = audioPatches
//        self.outputPatches = outputPatches
//        self.stageElements = stageElements
//        self._currentProject = currentProject
//        self.stageViewModel = stageViewModel
//    }
    
    var body: some View {
        ScrollView {
            VStack {
                
                if let projectName = projectManager.selectedProject?.projectName {
                    Text(projectName)
                        .font(.largeTitle)
                        .padding()
                }
                
                HStack{
                    Button("Save") {
                        saveProjectChanges()
                    }
                    Button("Create PDF") {
                        self.createAndShowPDF()
                    }
                }
                                
                Text("Input Patch").font(.headline).padding()
                HStack {
                    Text("Location").frame(width: 50)
                    Text("Patch No").frame(width: 50)
                    Text("Source").frame(width: 120)
                    Text("Mic/DI").frame(width: 100)
                    Text("Stand").frame(width: 80)
                    Text("Phantom").frame(width: 50)
                }
                .font(.subheadline)
                .padding(.bottom, 5)
                
                ForEach(audioPatches, id: \.self) { patch in
                    HStack {
                        Text(patch.location).frame(width: 50)
                        Text("\(patch.patchNumber)").frame(width: 50)
                        Text(patch.source).frame(width: 120)
                        Text(patch.micDI).frame(width: 100)
                        Text(patch.stand).frame(width: 80)
                        Text(patch.phantom ? "Yes" : "No").frame(width: 50)
                    }
                    Divider()
                }
                
                Divider()
                
                Text("Output Patch").font(.headline).padding()
                HStack {
//                    Text("Location").frame(width: 100)
                    Text("Patch No").frame(width: 50)
                    Text("Bus Type").frame(width: 100)
                    Text("Destination").frame(width: 100)
                    Text("Monitor Type").frame(width: 100)
                    Text("Stereo").frame(width: 60)
                }
                .font(.subheadline)
                .padding(.bottom, 5)
                
                ForEach(outputPatches, id: \.self) { patch in
                    HStack {
                        Text("\(patch.patchNumber)").frame(width: 50)
                        Text(patch.busType).frame(width: 100)
                        Text(patch.destination).frame(width: 100)
                        Text(patch.monitorType).frame(width: 100)
                        Text(patch.isStereo ? "Stereo" : "Mono").frame(width: 60)
                    }
                    Divider()
                }
                Button("Capture Stage Plot") {
                    self.capturedImage = self.stageViewModel.captureView()
                }
                
                // Affichage de l'image capturée si disponible
                if let capturedImage = capturedImage {
                    Image(nsImage: capturedImage)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        
        
//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                // Vérifier si le projet sélectionné est différent du dernier projet chargé ou si c'est le premier chargement
//                if let selectedProject = projectManager.selectedProject, lastLoadedProjectId != selectedProject.id {
//                    stageViewModel.load(from: selectedProject)
//                    print("Vue StagePlot chargée pour le projet : \(selectedProject.projectName).")
//
//                    // Mise à jour de l'ID du dernier projet chargé
//                    lastLoadedProjectId = selectedProject.id
//                }
//            }
//        }
    }
    private func captureCurrentView() {
            // Création de la vue que vous souhaitez capturer.
            // Par exemple, si vous souhaitez capturer la vue `StagePlotView`:
            let viewToCapture = StagePlotView(viewModel: stageViewModel)
            
            // Convertir cette vue en NSView.
            let nsView = NSHostingView(rootView: viewToCapture)
            
            // Utiliser la fonction capture de CaptureView.
        if let image = CaptureView<StagePlotView>.capture(from: nsView) {
                self.capturedImage = image
            }
        }
    
    private func writeImage(_ image: NSImage, to url: URL) {
        guard let tiffData = image.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffData),
              let pngData = bitmapImage.representation(using: .png, properties: [:]) else { return }
        do {
            try pngData.write(to: url)
            print("Image saved to \(url.path)")
        } catch {
            print("Failed to save image: \(error.localizedDescription)")
        }
    }
    func saveProjectChanges() {
        // Vérifiez d'abord si vous pouvez obtenir l'index du projet actuel
        if let projectIndex = projectManager.savedProjects.firstIndex(where: { $0.id == currentProject?.id }) {
            // Ensuite, faites une copie du projet que vous pouvez modifier
            var projectToUpdate = projectManager.savedProjects[projectIndex]

            // Appliquez vos mises à jour à cette copie
            projectToUpdate.audioPatches = self.audioPatches
            projectToUpdate.outputPatches = self.outputPatches
            projectToUpdate.stageElements = self.stageViewModel.stageElements

            // Réassignez la copie mise à jour au tableau original
            projectManager.savedProjects[projectIndex] = projectToUpdate

            // Log pour confirmer les mises à jour
            print("Projet \(projectToUpdate.projectName) sauvegardé avec \(projectToUpdate.stageElements.count) éléments de scène.")

            // Persistez les modifications
            projectManager.saveProjectsToUserDefaults()
        } else {
            // Gérez le cas où le projet actuel n'est pas trouvé dans le tableau
            print("Projet actuel non trouvé dans la liste des projets sauvegardés.")
        }
    }

    func createAndShowPDF(/*audioPatches: [AudioPatch], outputPatches: [OutputPatch]*/) {
        DispatchQueue.global(qos: .userInitiated).async {
            let size = CGSize(width: 595, height: 842) // Ajustez selon le besoin
            let image = NSImage(size: size)
            image.lockFocus()
            
            // Définir un fond blanc
            NSColor.white.set()
            NSRect(x: 0, y: 0, width: size.width, height: size.height).fill()
            
            let attributes = [
                NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: NSColor.black
            ]
            
            var yOffset = size.height - 50 // Commencez par le haut et ajustez selon vos besoins
            
            // general info
            //                let bandInfo = "Band Name: \(sharedData.bandName), Country: \(sharedData.country), Number of Musicians: \(sharedData.numberOfMusicians)"
            
            // Dessiner le contenu pour AudioPatch
            for patch in audioPatches {
                let string = "Location: \(patch.location), Patch No: \(patch.patchNumber), Source: \(patch.source), Mic/DI: \(patch.micDI), Stand: \(patch.stand), Phantom: \(patch.phantom ? "Yes" : "No")"
                let attrString = NSAttributedString(string: string, attributes: attributes)
                attrString.draw(at: CGPoint(x: 10, y: yOffset))
                yOffset -= 18 // Ajustez cette valeur pour espacer les lignes
            }
            
            // Ajoutez un espace entre les sections
            yOffset -= 30
            
            // Dessiner le contenu pour OutputPatch
            for patch in outputPatches {
                let string = "Location: \(patch.location), Patch No: \(patch.patchNumber), Bus Type: \(patch.busType), Destination: \(patch.destination), Monitor Type: \(patch.monitorType), Stereo: \(patch.isStereo ? "Stereo" : "Mono")"
                let attrString = NSAttributedString(string: string, attributes: attributes)
                attrString.draw(at: CGPoint(x: 10, y: yOffset))
                yOffset -= 18 // Ajustez cette valeur pour espacer les lignes
            }
            
            image.unlockFocus()
            
            // Sauvegardez l'image sur le bureau
            DispatchQueue.main.async {
                let capturedImage = self.captureStagePlotView()
//                self.stagePlotImage = Image(nsImage: capturedImage)
                let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
                let fileURL = desktopURL.appendingPathComponent("capturedImage.png")
                
                if let tiffData = capturedImage.tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffData), let data = bitmapImage.representation(using: .png, properties: [:]) {
                    do {
                        try data.write(to: fileURL)
                        print("Image saved to \(fileURL.path)")
                    } catch {
                        print("Failed to save image: \(error)")
                    }
                }
                
                let savePanel = NSSavePanel()
                savePanel.allowedContentTypes = [.png]
                savePanel.canCreateDirectories = true
                savePanel.showsTagField = false
                savePanel.title = "Save Exported Image"
                savePanel.message = "Choose a location to save the exported image."
                savePanel.nameFieldStringValue = "ExportedImage.png"
                savePanel.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first
                
                savePanel.begin { response in
                    if response == .OK, let url = savePanel.url {
                        do {
                            guard let tiffData = image.tiffRepresentation,
                                  let bitmapImage = NSBitmapImageRep(data: tiffData),
                                  let pngData = bitmapImage.representation(using: .png, properties: [:]) else { return }
                            
                            try pngData.write(to: url)
                            print("Image saved at: \(url.path)")
                        } catch {
                            print("Error saving image: \(error)")
                        }
                    }
                }
            }
        }
    }
    func captureStagePlotView() -> NSImage {
        let targetSize = CGSize(width: 1600, height: 1200) // Taille cible pour l'image capturée
        let image = NSImage(size: targetSize)
        
        image.lockFocus()
        
        // Fond de l'image
        NSColor.white.setFill()
        NSBezierPath(rect: NSRect(origin: .zero, size: targetSize)).fill()
        
        // Dessiner chaque élément de la scène
        for element in stageElements {
            drawStageElement(element, in: image, size: targetSize)
        }
        image.unlockFocus()
        return image
    }
    
    func drawStageElement(_ element: StageElement, in image: NSImage, size: CGSize) {
        let position = CGPoint(x: element.positionXPercent * size.width, y: element.positionYPercent * size.height)
        let color = getColor(for: element.type) // Assurez-vous que cette méthode retourne NSColor
        let path = NSBezierPath() // Utilisez la forme appropriée en fonction du type d'élément
        
        // Exemple de dessin d'un élément carré
        let elementSize: CGFloat = 50 // Taille de l'élément, à ajuster selon le type
        let rect = CGRect(x: position.x - elementSize / 2, y: position.y - elementSize / 2, width: elementSize, height: elementSize)
        path.appendRect(rect)
        
        color.setFill()
        path.fill()
    }
    
    func getColor(for type: ElementType) -> NSColor {
        switch type {
            // Exemple de couleurs pour différents types, ajustez selon vos besoins
        case .riser2x2, .riser3x2, .riser2x1, .riser4x3 /*.amplifier, .keys*/:
            return NSColor.gray
        case .powerOutlet, .patchBox:
            return NSColor.orange
        case .source, .musician:
            return NSColor.black
        case .wedge, .side, .iem:
            return NSColor.blue
//        case .iem:
//            return NSColor.blue
        }
    }
    
    
    func drawProjectName(on image: NSImage, projectName: String, in size: CGSize) {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 20),
            .foregroundColor: NSColor.black
        ]
        
        let string = NSString(string: projectName)
        let stringSize = string.size(withAttributes: attrs)
        let stringRect = CGRect(x: (size.width - stringSize.width) / 2, y: size.height - stringSize.height - 20, width: stringSize.width, height: stringSize.height)
        string.draw(in: stringRect, withAttributes: attrs)
    }
    func renderViewToImage<T: View>(_ view: T, size: CGSize) -> NSImage {
        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(origin: .zero, size: size)
        hostingView.wantsLayer = true
        
        let image = NSImage(size: size)
        image.lockFocus()
        
        // Dessiner un fond blanc avec CGContext
        if let context = NSGraphicsContext.current?.cgContext {
            context.setFillColor(NSColor.white.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            
            let attributes = [
                NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: NSColor.black
            ]
            var yOffset = size.height - 20 // Commencez par le haut de l'image et ajustez selon vos besoins
            
            for patch in audioPatches {
                let string = "Location: \(patch.location), Patch No: \(patch.patchNumber), Source: \(patch.source), Mic/DI: \(patch.micDI), Stand: \(patch.stand), Phantom: \(patch.phantom ? "Yes" : "No")"
                let attrString = NSAttributedString(string: string, attributes: attributes)
                attrString.draw(at: CGPoint(x: 10, y: yOffset))
                yOffset -= 20 // Ajustez cette valeur pour espacer les lignes
            }
        }
        image.unlockFocus()
        return image
    }
    //    func createPDF(from image: NSImage) -> Data? {
    //        let pdfData = NSMutableData()
    //        let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
    //        var mediaBox = CGRect(origin: .zero, size: image.size)
    //        guard let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil) else { return nil }
    //
    //        pdfContext.beginPDFPage(nil)
    //        // Définir un fond blanc
    //        pdfContext.setFillColor(CGColor.white)
    //        pdfContext.fill(mediaBox)
    //        // Dessiner l'image
    //        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
    //        pdfContext.draw(cgImage, in: mediaBox)
    //        pdfContext.endPDFPage()
    //        pdfContext.closePDF()
    //
    //        return pdfData as Data
    //    }
    //    func saveImageWithPanel(pdfImage: NSImage) {
    //        let savePanel = NSSavePanel()
    //        savePanel.allowedFileTypes = ["png"]
    //        savePanel.canCreateDirectories = true
    //        savePanel.showsTagField = false
    //        savePanel.title = "Save Image"
    //        savePanel.message = "Choose a location to save the image."
    //        savePanel.nameFieldStringValue = "ExportedImage.png"
    //        savePanel.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first
    //
    //        savePanel.begin { response in
    //            if response == .OK, let url = savePanel.url {
    //                do {
    //                    guard let tiffData = pdfImage.tiffRepresentation,
    //                          let bitmapImage = NSBitmapImageRep(data: tiffData),
    //                          let pngData = bitmapImage.representation(using: .png, properties: [:]) else { return }
    //
    //                    try pngData.write(to: url)
    //                    print("Image saved at: \(url.path)")
    //                } catch {
    //                    print("Error saving image: \(error)")
    //                }
    //            }
    //        }
    //    }
    //    func showSavePanel() {
    //        let savePanel = NSSavePanel()
    //        savePanel.allowedFileTypes = ["png"]
    //        savePanel.canCreateDirectories = true
    //        savePanel.showsTagField = false
    //        savePanel.title = "Sauvegarder l'image"
    //        savePanel.message = "Choisissez l'emplacement pour sauvegarder l'image."
    //        savePanel.nameFieldStringValue = "ImageExportée.png"
    //        savePanel.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first
    //
    //        savePanel.begin { response in
    //            if response == .OK, let url = savePanel.url {
    //                // Ici, vous sauvegardez vos données à l'URL sélectionnée
    //                // Par exemple, sauvegarder une image
    //                //                saveImageToDisk(image: renderViewToImage(), at: url)
    //            }
    //        }
    //    }
}
//struct PDFViewer: NSViewRepresentable {
//    var pdfDocument: PDFDocument
//
//    func makeNSView(context: Context) -> PDFView {
//        let pdfView = PDFView()
//        pdfView.document = pdfDocument
//        pdfView.autoScales = true
//        return pdfView
//    }
//    func updateNSView(_ nsView: PDFView, context: Context) {}
//}
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
//    }
//}


extension NSImage {
    func asImage() -> Image {
        Image(nsImage: self)
    }
}
