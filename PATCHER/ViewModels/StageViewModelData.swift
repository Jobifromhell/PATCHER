//import SwiftUI
//
//extension StageViewModel {
//    // Method to load data from project
//    func load(from project: Project) {
//        self.stageElements = project.stageElements
//        print("Chargement des éléments de scène pour le projet : \(project.projectName), \(stageElements.count) éléments chargés.")
//    }
//
//    // Method to update element
//    func updateElement(_ element: StageElement) {
//        if let index = stageElements.firstIndex(where: { $0.id == element.id }) {
//            stageElements[index] = element
//        }
//    }
//
//    // Method to initialize alignment lines
//    func initializeAlignmentLines() {
//        let xSpacing: CGFloat = 10
//        let ySpacing: CGFloat = 10
//        
//        xAlignmentLines = (0...Int(stageWidth / xSpacing)).map { CGFloat($0) * xSpacing }
//        yAlignmentLines = (0...Int(stageHeight / ySpacing)).map { CGFloat($0) * ySpacing }
//    }
//
//    // Method to add element to stage
//    func addElement(_ type: ElementType, name: String, patch: String = "", detail: String = "", at position: CGPoint) {
//        let newElement = StageElement(
//            id: UUID(),
//            name: name,
//            type: type,
//            positionXPercent: position.x / stageWidth,
//            positionYPercent: position.y / stageHeight,
//            rotation: Angle(degrees: 0),
//            patch: patch,
//            detail: detail, // Pas besoin du ? ici car detail est déjà optionnel dans la déclaration
//            isSelected: false,
//            zIndex: 0
//        )
//        
//        stageElements.append(newElement)
//        print("Élément ajouté : \(newElement)")
//    }
//
//    // Method to clear all stage elements
//    func clearAllStageElements() {
//        stageElements.removeAll()
//    }
//
//    // Method to bring element to front
//    func bringElementToFront(_ elementId: UUID) {
//        // Trouvez l'élément sélectionné et donnez-lui le zIndex le plus élevé
//        if let selectedIndex = stageElements.firstIndex(where: { $0.id == elementId }) {
//            let highestZIndex = (stageElements.max(by: { $0.zIndex < $1.zIndex })?.zIndex ?? 0) + 1
//            stageElements[selectedIndex].zIndex = highestZIndex
//        }
//    }
//
//    // Method to update element with new name or type
//    func updateElement(_ elementId: UUID, newName: String? = nil, newType: ElementType? = nil) {
//        if let index = stageElements.firstIndex(where: { $0.id == elementId }) {
//            if let newName = newName {
//                stageElements[index].name = newName
//            }
//            if let newType = newType {
//                stageElements[index].type = newType
//                stageElements[index].updateZIndex()
//            }
//        }
//    }
//
//    // Method to update position of element
//    func updatePosition(of elementId: UUID, toXPercent xPercent: CGFloat, toYPercent yPercent: CGFloat) {
//        guard let index = stageElements.firstIndex(where: { $0.id == elementId }) else { return }
//        stageElements[index].positionXPercent = xPercent
//        stageElements[index].positionYPercent = yPercent
//    }
//
//    // Method to align position
//    func alignPosition(_ position: CGPoint) -> CGPoint {
//        // Directement accéder aux propriétés sans utiliser 'viewModel.'
//        let alignedX = calculateClosestAlignment(position.x, alignmentLines: xAlignmentLines)
//        let alignedY = calculateClosestAlignment(position.y, alignmentLines: yAlignmentLines)
//        return CGPoint(x: alignedX, y: alignedY)
//    }
//
//    // Method to calculate closest alignment
//    func calculateClosestAlignment(_ value: CGFloat, alignmentLines: [CGFloat]) -> CGFloat {
//        let closestLine = alignmentLines.min(by: { abs($0 - value) < abs($1 - value) }) ?? value
//        return closestLine
//    }
//}
