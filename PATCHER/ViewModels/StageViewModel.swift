//
//  StageViewModel.swift
//  StageOrganizerSwiftUI
//
//  Created by Olivier Jobin on 11/02/2024.
//

import SwiftUI
import AppKit

class StageViewModel: ObservableObject {
    
    @Published var availableOutputs: [String] = ["Output1", "Output2", "Output3"]
    
    @Published var selectedElementTypes: Set<ElementType> = Set(ElementType.allCases)
    @Published var categorySelections: [ElementType: Bool] = [
        .source: true, /*.amplifier: true, *//*.keys: true,*/ .riser3x2: true, .riser2x1: true, .riser2x2: true, .riser4x3: true,
        .patchBox: true, .powerOutlet: true, .wedge: true, .iem: true, .side: true, .musician: true
    ]
    //    @EnvironmentObject var viewModel: StageViewModel
    @Published var stageElements: [StageElement] = []
    @Published var selectedGroup: String? = nil
    //    @EnvironmentObject var sharedViewModel: SharedViewModel
    @Published var stageWidth: CGFloat = 800 {
        didSet {
            initializeAlignmentLines()
        }
    }
    @Published var stageHeight: CGFloat = 600 {
        didSet {
            initializeAlignmentLines()
        }
    }
    @Published var initialStageWidth: CGFloat = 1000 // valeur initiale
    @Published var initialStageHeight: CGFloat = 1000 // valeur initiale

    var audioPatches: [AudioPatch]
    var outputPatches: [OutputPatch]
    
    var xAlignmentLines: [CGFloat] = []
    var yAlignmentLines: [CGFloat] = []
    
    init(audioPatches: [AudioPatch], outputPatches: [OutputPatch], stageElements: [StageElement]) {
        self.audioPatches = audioPatches
        self.outputPatches = outputPatches
        initializeAlignmentLines()
        NotificationCenter.default.addObserver(self, selector: #selector(loadProjectElements), name: Notification.Name("ProjectSelected"), object: nil)
        
    }
    @objc func loadProjectElements(notification: Notification) {
        if let project = notification.userInfo?["project"] as? Project {
            // Chargez ici les éléments de scène du projet
            print("Loaded project elements: \(project.stageElements)")

            self.stageElements = project.stageElements
        }
    }
    
    func saveElementChanges(_ element: StageElement) {
        if let index = stageElements.firstIndex(where: { $0.id == element.id }) {
            stageElements[index] = element
            print("Modifications de l'élément sauvegardées.")
        }
    }
    // Méthode pour charger les données à partir d'un projet spécifié
    func load(from project: Project) {
        self.stageElements = project.stageElements
        print("Chargement des éléments de scène pour le projet : \(project.projectName), \(stageElements.count) éléments chargés.")
    }
    
    func updateElement(_ element: StageElement) {
        if let index = stageElements.firstIndex(where: { $0.id == element.id }) {
            stageElements[index] = element
        }
    }
    
    
    func initializeAlignmentLines() {
        let xSpacing: CGFloat = 10
        let ySpacing: CGFloat = 10
        
        xAlignmentLines = (0...Int(stageWidth / xSpacing)).map { CGFloat($0) * xSpacing }
        yAlignmentLines = (0...Int(stageHeight / ySpacing)).map { CGFloat($0) * ySpacing }
    }
    
    func addElement(_ type: ElementType, name: String, patch: String = "", detail: String = "", at position: CGPoint) {
        let newElement = StageElement(
            id: UUID(),
            name: name,
            type: type,
            positionXPercent: position.x / stageWidth,
            positionYPercent: position.y / stageHeight,
            rotation: Angle(degrees: 0),
            patch: patch,
            detail: detail, // Pas besoin du ? ici car detail est déjà optionnel dans la déclaration
            isSelected: false,
            zIndex: 0
        )
        
        stageElements.append(newElement)
        print("Élément ajouté : \(newElement)")
    }
    
    func clearAllStageElements() {
        stageElements.removeAll()
    }

    
    func bringElementToFront(_ elementId: UUID) {
        if let selectedIndex = stageElements.firstIndex(where: { $0.id == elementId }) {
            let highestZIndex = (stageElements.max(by: { $0.zIndex < $1.zIndex })?.zIndex ?? 0) + 1
            stageElements[selectedIndex].zIndex = highestZIndex
        }
    }
    func bringElementToBack(_ elementId: UUID) {
        guard let selectedIndex = stageElements.firstIndex(where: { $0.id == elementId }) else { return }
        
        // Obtenir l'élément actuel et réduire son zIndex au minimum trouvé
        let currentMinZIndex = stageElements.min(by: { $0.zIndex < $1.zIndex })?.zIndex ?? 0
        stageElements[selectedIndex].zIndex = currentMinZIndex - 1
        
        // Optionnellement, réorganiser tous les éléments pour s'assurer qu'ils ont des zIndex uniques et cohérents
        reorderZIndexes()
    }

    func reorderZIndexes() {
        stageElements.sort(by: { $0.zIndex < $1.zIndex })
        for (index, element) in stageElements.enumerated() {
            stageElements[index].zIndex = index
        }
    }

    
    func updateElement(_ elementId: UUID, newName: String? = nil, newType: ElementType? = nil) {
        if let index = stageElements.firstIndex(where: { $0.id == elementId }) {
            if let newName = newName {
                stageElements[index].name = newName
            }
            if let newType = newType {
                stageElements[index].type = newType
                stageElements[index].updateZIndex()
            }
        }
    }
    
    func updatePosition(of elementId: UUID, toXPercent xPercent: CGFloat, toYPercent yPercent: CGFloat) {
        guard let index = stageElements.firstIndex(where: { $0.id == elementId }) else { return }
        stageElements[index].positionXPercent = xPercent
        stageElements[index].positionYPercent = yPercent
    }
    
    func alignPosition(_ position: CGPoint) -> CGPoint {
        // Directement accéder aux propriétés sans utiliser 'viewModel.'
        let alignedX = calculateClosestAlignment(position.x, alignmentLines: xAlignmentLines)
        let alignedY = calculateClosestAlignment(position.y, alignmentLines: yAlignmentLines)
        return CGPoint(x: alignedX, y: alignedY)
    }
    
    func calculateClosestAlignment(_ value: CGFloat, alignmentLines: [CGFloat]) -> CGFloat {
        let closestLine = alignmentLines.min(by: { abs($0 - value) < abs($1 - value) }) ?? value
        return closestLine
    }
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
    func saveStageElements(_ elements: [StageElement], to url: URL) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(elements)
            try data.write(to: url)
            print("Éléments de la scène sauvegardés avec succès : \(elements.count) éléments.")
        } catch {
            print("Erreur lors de la sauvegarde des éléments de la scène : \(error)")
        }
    }
    
    func loadStageElements(from url: URL) -> [StageElement]? {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let elements = try decoder.decode([StageElement].self, from: data)
            return elements
        } catch {
            print("Failed to load stage elements: \(error)")
            return nil
        }
    }
    
    private func saveImage(_ image: NSImage) {
        // Implement the logic to save 'image' to disk or handle it as needed.
        // This could involve using an NSSavePanel, writing to a file, etc.
    }
}

    // Fonction pour capturer la vue en tant qu'image
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
    
//    private func contentToCapture() -> some View {
//        StagePlotView(viewModel: self) // Assurez-vous que ceci correspond à votre structure de vue correcte
//    }
//}
