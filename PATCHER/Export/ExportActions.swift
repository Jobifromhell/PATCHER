import SwiftUI
import Foundation
import AppKit

extension ExportView {
    
    
    func createAndShowPDF() {
        let pdfData = generatePDFData()
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["pdf"]
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.title = "Save PDF"
        savePanel.message = "Choose a location to save the PDF file."
        savePanel.nameFieldStringValue = "ExportedFile.pdf"
        savePanel.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first
        
        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                do {
                    try pdfData.write(to: url)
                    print("PDF saved at: \(url.path)")
                } catch {
                    print("Error saving PDF: \(error)")
                }
            }
        }
    }
    
    func generatePDFData() -> Data {
        let pdfData = NSMutableData()
        var totalPatchRows = sharedViewModel.audioPatches.count + sharedViewModel.outputPatches.count // Nombre total de lignes de patch
        
        // Calcul de la hauteur des cellules de tableau
         let cellHeight: CGFloat = 25 // Vous devez ajuster cette valeur en fonction de votre mise en page

        // Utilisons les dimensions d'une page A4 standard pour le PDF
           let pageWidth: CGFloat = 595.2 // A4 width in points
           let pageHeight: CGFloat = 841.8 // A4 height in points

           // Créez la page PDF avec les dimensions A4
           let pdfConsumer = CGDataConsumer(data: pdfData)!
           var mediaBox = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
           guard let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil) else {
               fatalError("Failed to create PDF context")
           }

           pdfContext.beginPDFPage(nil)
           let context = NSGraphicsContext(cgContext: pdfContext, flipped: false)
           NSGraphicsContext.current = context

           // Position de départ pour le dessin des tables
           let startYPosition: CGFloat = pageHeight - 150 // Commencez à dessiner 100 points à partir du haut de la page
        Text ("INPUT PATCH")
           drawHeader(context: pdfContext, pageWidth: pageWidth)

           // Dessinez le tableau des patchs audio d'entrée avec les intitulés de colonnes
           drawAudioPatchTable(at: CGPoint(x: 30, y: startYPosition), withColumnTitles: ["From", "", "Source", "Mic/DI", "Stand", "+48V"])

           // Calculez la nouvelle position Y après avoir dessiné la première table
        let newStartPositionY = startYPosition - CGFloat(sharedViewModel.audioPatches.count) * cellHeight - 40 // 40 points d'espacement entre les tables

           // Vérifiez que la nouvelle position Y est positive pour éviter de dessiner en dehors de la page
           guard newStartPositionY > 0 else {
               fatalError("La table des patchs audio dépasse la hauteur de la page")
           }
        Text ("OUTPUT PATCH")

           // Dessinez le tableau des patchs de sortie avec les intitulés de colonnes
           drawOutputPatchTable(at: CGPoint(x: 30, y: newStartPositionY), withColumnTitles: ["", "Bus", "Destination", "Monitor Type"])

           drawFooter(context: pdfContext, pageWidth: pageWidth, pageHeight: pageHeight)

           pdfContext.endPDFPage()
           pdfContext.closePDF()

           return pdfData as Data
       }
    func drawHeader(context: CGContext, pageWidth: CGFloat) {
        let headerText = "DEMO PROJECT" as NSString
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: 18),
            .foregroundColor: NSColor.black
        ]
        let headerSize = headerText.size(withAttributes: headerAttributes)
        let headerRect = CGRect(x: (pageWidth - headerSize.width) / 2, y: 750, width: headerSize.width, height: headerSize.height)
        headerText.draw(in: headerRect, withAttributes: headerAttributes)
    }
    
    func drawFooter(context: CGContext, pageWidth: CGFloat, pageHeight: CGFloat) {
           let footerText = "Made with PATCHER" as NSString
           let footerAttributes: [NSAttributedString.Key: Any] = [
               .font: NSFont.systemFont(ofSize: 12),
               .foregroundColor: NSColor.black
           ]
           let footerSize = footerText.size(withAttributes: footerAttributes)
           let footerRect = CGRect(x: 10, y: 10, width: footerSize.width, height: footerSize.height)
           footerText.draw(in: footerRect, withAttributes: footerAttributes)
       }
    func drawAudioPatchTable(at startPoint: CGPoint, withColumnTitles columnTitles: [String]) {
        var columnWidths: [CGFloat] = [35, 30, 80, 60, 70, 40] // Défaut pour chaque colonne
        let cellHeight: CGFloat = 25
        
        // Dessiner les intitulés de colonnes
        var currentX = startPoint.x
            for (index, title) in columnTitles.enumerated() {
                let width = columnWidths[index]
                let rect = CGRect(x: currentX, y: startPoint.y, width: width, height: cellHeight)
                title.draw(in: rect, withAttributes: [.font: NSFont.boldSystemFont(ofSize: 12)])
                currentX += width + 20 // Ajoutez un espacement supplémentaire pour séparer les colonnes
            }
        
        // Calculer la largeur maximale pour chaque colonne en fonction du texte le plus long
        // Utilisez audioPatches pour les patchs d'entrée
        for patch in sharedViewModel.audioPatches {
            let strings = [patch.location, "\(patch.patchNumber)", patch.source, patch.micDI, patch.stand, patch.phantom ? "+48V" : ""]
            for (index, string) in strings.enumerated() {
                let size = string.size(withAttributes: [.font: NSFont.systemFont(ofSize: 12)])
                columnWidths[index] = max(columnWidths[index], size.width + 20) // Ajoutez une marge pour un meilleur aspect visuel
            }
        }
        
        var currentY = startPoint.y - cellHeight // Déplacez-vous vers le haut pour dessiner les données
        for patch in sharedViewModel.audioPatches {
            currentX = startPoint.x // Réinitialiser la position horizontale pour dessiner les données de chaque patch
            let strings = [patch.location, "\(patch.patchNumber)", patch.source, patch.micDI, patch.stand, patch.phantom ? "Yes" : "No"]
            for (index, string) in strings.enumerated() {
                let rect = CGRect(x: currentX, y: currentY, width: columnWidths[index], height: cellHeight)
                string.draw(in: rect, withAttributes: [.font: NSFont.systemFont(ofSize: 12)])
                currentX += columnWidths[index]
            }
            currentY -= cellHeight
        }
    }

    func drawOutputPatchTable(at startPoint: CGPoint, withColumnTitles columnTitles: [String]) {
        var columnWidths: [CGFloat] = [15, 25, 90, 80] // Défaut pour chaque colonne
        let cellHeight: CGFloat = 25
        
        // Dessiner les intitulés de colonnes
        var currentX = startPoint.x
            for (index, title) in columnTitles.enumerated() {
                let width = columnWidths[index]
                let rect = CGRect(x: currentX, y: startPoint.y, width: width, height: cellHeight)
                title.draw(in: rect, withAttributes: [.font: NSFont.boldSystemFont(ofSize: 12)])
                currentX += width + 20 // Ajoutez un espacement supplémentaire pour séparer les colonnes
            }
        
        // Utilisez outputPatches pour les patchs de sortie
        for patch in outputPatches {
            let strings = ["\(patch.patchNumber)", patch.busType, patch.destination, patch.monitorType]
            for (index, string) in strings.enumerated() {
                let size = string.size(withAttributes: [.font: NSFont.systemFont(ofSize: 12)])
                columnWidths[index] = max(columnWidths[index], size.width + 20) // Ajoutez une marge pour un meilleur aspect visuel
            }
        }
        
        var currentY = startPoint.y - cellHeight // Déplacez-vous vers le haut pour dessiner les données
        for patch in outputPatches {
            currentX = startPoint.x // Réinitialiser la position horizontale pour dessiner les données de chaque patch
            let strings = ["\(patch.patchNumber)", patch.busType, patch.destination, patch.monitorType]
            for (index, string) in strings.enumerated() {
                let rect = CGRect(x: currentX, y: currentY, width: columnWidths[index], height: cellHeight)
                string.draw(in: rect, withAttributes: [.font: NSFont.systemFont(ofSize: 12)])
                currentX += columnWidths[index]
            }
            currentY -= cellHeight
        }
    }


    
    
    // Dessine les données pour un patch audio spécifique
    func drawAudioPatch(_ patch: AudioPatch, at startPoint: CGPoint) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12),
            .foregroundColor: NSColor.black
        ]
        
        var currentX = startPoint.x
        let cellWidth: CGFloat = 100 // Largeur de cellule de base
        
        let locationString = NSAttributedString(string: patch.location, attributes: attributes)
        let patchNoString = NSAttributedString(string: "\(patch.patchNumber)", attributes: attributes)
        let sourceString = NSAttributedString(string: patch.source, attributes: attributes)
        let micDIString = NSAttributedString(string: patch.micDI, attributes: attributes)
        let standString = NSAttributedString(string: patch.stand, attributes: attributes)
        let phantomString = NSAttributedString(string: patch.phantom ? "+48" : "", attributes: attributes)
        
        let strings = [locationString, patchNoString, sourceString, micDIString, standString, phantomString]
        
        var maxWidth: CGFloat = 0 // Pour stocker la largeur maximale de la cellule
        
        for string in strings {
            let size = string.size() // Taille du texte
            maxWidth = max(maxWidth, size.width) // Mettre à jour la largeur maximale
        }
        
        for string in strings {
            string.draw(at: CGPoint(x: currentX, y: startPoint.y))
            currentX += maxWidth + 20 // Ajouter un espace après chaque cellule
        }
    }

  
        
    // Dessine les données pour un patch de sortie spécifique
    func drawOutputPatch(_ patch: OutputPatch, at startPoint: CGPoint) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12),
            .foregroundColor: NSColor.black
        ]
        
        var currentX = startPoint.x
        let cellWidth: CGFloat = 100 // Largeur de cellule de base
        
        let patchNoString = NSAttributedString(string: "Patch No: \(patch.patchNumber)", attributes: attributes)
        let typeString = NSAttributedString(string: "Type: \(patch.busType)", attributes: attributes)
        let destinationString = NSAttributedString(string: "Destination: \(patch.destination)", attributes: attributes)
        let monitorType = NSAttributedString (string: "Type: \(patch.monitorType)",attributes: attributes)
                                              
        let strings = [patchNoString, typeString, destinationString]
        
        var maxWidth: CGFloat = 0 // Pour stocker la largeur maximale de la cellule
        
        for string in strings {
            let size = string.size() // Taille du texte
            maxWidth = max(maxWidth, size.width) // Mettre à jour la largeur maximale
        }
        
        for string in strings {
            string.draw(at: CGPoint(x: currentX, y: startPoint.y))
            currentX += maxWidth + 20 // Ajouter un espace après chaque cellule
        }
    }
}
