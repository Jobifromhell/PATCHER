////
////  InputPatchActions.swift
////  StageOrganizerSwiftUI
////
////  Created by Olivier Jobin on 11/02/2024.
////
//
//import SwiftUI
//
//extension InputPatchView {
//    
//    func addNewItem() {
//        withAnimation {
//            let newPatch = AudioPatch(patchNumber: nextPatchNumber, source: newInstrument, micDI: newMic, stand: newMicStand, phantom: newPhantom, group: selectedGroup)
//            sharedViewModel.audioPatches.append(newPatch)
//            // Appel à la fonction pour mettre à jour les données de patch
//            sharedViewModel.updatePatchNumbers() // Ajoutez cet appel
//            sharedViewModel.audioPatches.append(newPatch)
//
//            // Réinitialisation des champs après l'ajout
//            newInstrument = ""
//            newMic = ""
//            newMicStand = ""
//            newPhantom = false
//            selectedGroup = "A"
//            selectedLocation = "STAGE"
//        }
//    }
//
//    
//    func move(from source: IndexSet, to destination: Int) {
//        sharedViewModel.audioPatches.move(fromOffsets: source, toOffset: destination)
//        // Mettre à jour les données de patch
//        sharedViewModel.updatePatchNumbers() // Ajoutez cet appel
//        
//    }
//    
//    func delete(offsets: IndexSet) {
//        sharedViewModel.audioPatches.remove(atOffsets: offsets)
//        sharedViewModel.updatePatchNumbers() // Ajoutez cet appel
//    }
//    func deleteItem(patch: AudioPatch) {
//        withAnimation {
//            if let index = audioPatches.firstIndex(where: { $0.id == patch.id }) {
//                sharedViewModel.audioPatches.remove(at: index)
//                // Appel à la fonction pour mettre à jour les numéros de patch
//                sharedViewModel.updatePatchNumbers()
//            }
//        }
//    }
//
//    func updatePatchNumbers() {
//        // Parcours toutes les lignes d'entrée et met à jour les numéros de patch en fonction de l'ordre actuel
//        for index in audioPatches.indices {
//            sharedViewModel.audioPatches[index].patchNumber = index + 1
//        }
//        // Ajouter un print pour vérifier
//        print("Patch numbers updated: \(audioPatches)")
//    }
//
//
//
//    func updateGroupSelection(newGroup: String) {
//        sharedViewModel.selectedGroup = newGroup
//    }
//    
//}
