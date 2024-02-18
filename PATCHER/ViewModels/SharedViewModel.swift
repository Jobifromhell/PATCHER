import Foundation
import SwiftUI

class SharedViewModel: ObservableObject {
//    @Published var audioPatches: [AudioPatch] = []
//    @Published var outputPatches: [OutputPatch] = []
//    @Published var availableDestinations: [String] = []{
//        didSet {
//            // Mettez à jour les destinations disponibles lorsque les outputPatches sont modifiés
//            fetchOutputPatchDestinations()
//        }
//    }
    @Published var outputPatchDestinations: [String] = []{
        didSet {
            // Mettez à jour les destinations disponibles lorsque les outputPatches sont modifiés
            fetchOutputPatchDestinations()
        }
    }
//    @Published var destinationOptions: [String] = []

      
    @Published var outputPatches: [OutputPatch] = [] 
//    {
//           didSet {
//               // Mettez à jour les destinations disponibles lorsque les outputPatches sont modifiés
//               fetchOutputPatchDestinations()
//           }
//       }
    @Published var audioPatches: [AudioPatch] = [] 
//    {
//        didSet {
//            self.objectWillChange.send()
//            print("Audio patches updated:")
//            for patch in audioPatches {
//                print("Patch: \(patch.patchNumber), Source: \(patch.source), Mic/DI: \(patch.micDI), Stand: \(patch.stand), Phantom: \(patch.phantom), Group: \(patch.group)")
//            }
//
//        OPTION MAJ AFFICHAGE
//        }
//    }
    @Published var patchIndicator = 0
    @Published var stageElements: [StageElement] = []
    @Published var filteredStageElements: [StageElement] = []

    @Published var selectedGroup: String? = nil {
        didSet {
            print("Selected group changed to: \(selectedGroup ?? "none")")
            updateFilteredElements()
            
        }
    }
    private var nextPatchNumber: Int {
        (audioPatches.last?.patchNumber ?? 0) + 1
    }
    let groupOptions = (65...90).map { String(UnicodeScalar($0)) } // Génère un tableau de "A" à "Z"

//    // Cette fonction retourne les numéros de patch pour un groupe donné
//    func patchNumbers(forGroup group: String) -> [Int] {
//        let filteredPatches = audioPatches.filter { $0.group == group }
//        return filteredPatches.map { $0.patchNumber }
//    }
    // Une fonction pour mettre à jour les éléments filtrés basée sur le groupe sélectionné
    
    func clearAllStageElements() {
        withAnimation {
            stageElements.removeAll()
            self.objectWillChange.send()

        }
    }


    func fetchOutputPatchDestinations() {
        // Créer un tableau temporaire pour stocker les destinations extraites
            var destinations: Set<String> = []

            // Parcourir tous les patches de sortie
            for patch in outputPatches {
                // Extraire la destination de chaque patch et l'ajouter au tableau
                destinations.insert(patch.destination)
            }

            // Convertir le tableau de destinations en tableau ordonné et le mettre à jour dans outputPatchDestinations
            outputPatchDestinations = destinations.sorted()
        
//        // Récupérer les destinations à partir des outputPatches
//           let destinations = outputPatches.map { $0.destination }
//
//           // Mettre à jour les destinations disponibles
//           outputPatchDestinations = Array(Set(destinations)) // Pour éliminer les doublons

    }

    
    private func updateFilteredElements() {
        if let group = selectedGroup, !group.isEmpty {
            // Filtrer les éléments basés sur le groupe sélectionné
            filteredStageElements = stageElements.filter { $0.group == group }
        } else {
            // Si aucun groupe n'est sélectionné, montrer tous les éléments
            filteredStageElements = stageElements
        }
        // Cela déclenchera la mise à jour des vues observant filteredStageElements
    }
    func patchNumbers(forGroup group: String) -> [Int] {
           audioPatches.filter { $0.group == group }.map { $0.patchNumber }
       }
   

    
    // Ajoutez cette fonction pour récupérer les éléments de scène pour un groupe spécifique
    func elements(forGroup group: String) -> [StageElement] {
        // Filtrer les éléments de scène en fonction du groupe
        let filteredElements = stageElements.filter { $0.group == group }
        print("Éléments filtrés pour le groupe \(group): \(filteredElements)")
        return filteredElements
    }
    func notifyPatchChange() {
        NotificationCenter.default.post(name: NSNotification.Name("PatchDataChanged"), object: nil)
    }
    func updatePatchData() {
        // Mettre à jour les données de patch dans SharedViewModel
        updatePatchNumbers()
        // Notifier les observateurs que la liste des patches a été mise à jour
        self.objectWillChange.send()
         }

    func updatePatchNumbers() {
        // Créez une copie mutable de audioPatches
        var updatedPatches = audioPatches
        
        // Parcours toutes les lignes d'entrée et met à jour les numéros de patch en fonction de l'ordre actuel
        for (index, _) in updatedPatches.enumerated() {
            updatedPatches[index].patchNumber = index + 1
        }
        self.objectWillChange.send()

        // Remplacez audioPatches par la version mise à jour
        audioPatches = updatedPatches
    }

//    func addNewPatch() {
//        let newPatch = AudioPatch(patchNumber: nextPatchNumber, source: "", micDI: "", stand: "", phantom: false, group: selectedGroup ?? "")
//        audioPatches.append(newPatch)
//        self.objectWillChange.send()
//
//    }

}
