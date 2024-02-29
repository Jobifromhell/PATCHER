
import SwiftUI

extension OutputPatchView{
       func addPatch(isStereo: Bool) {
        let newPatchNumber = nextPatchNumber
        var newPatch = OutputPatch(
            patchNumber: newPatchNumber,
            busType: newBusType,
            destination: newDestination,
            monitorType: newMonitorType,
            isStereo: isStereo
        )
        updateOutputPatchDestinations(with: newPatch.destination)
        sharedViewModel.updateAvailableOutputDestinations()
        sharedViewModel.outputPatches.append(newPatch)
        sharedViewModel.updatePatchNumbers()
        
        if isStereo {
            newPatch.destination += " L" // Indiquez que c'est la sortie gauche
        }
        // Réinitialisez les valeurs par défaut
        self.newBusType = "BUS"
        self.newDestination = "DESTINATION"
        self.newMonitorType = "TYPE"
    }
    
       func updateOutputPatchDestinations(with newDestination: String) {
        if !sharedViewModel.outputPatchDestinations.contains(newDestination) {
            sharedViewModel.outputPatchDestinations.append(newDestination)
        }
    }
    
    func handleStereoChange(for patch: Binding<OutputPatch>, isStereo: Bool) {
        guard let index = sharedViewModel.outputPatches.firstIndex(where: { $0.id == patch.wrappedValue.id }) else { return }
        
        if isStereo {
            // Activer le mode stéréo
            patch.wrappedValue.isStereo = true
            patch.wrappedValue.destination += " L" // Ajouter le suffixe "L"
            
            // Ajouter la sortie droite si elle n'existe pas déjà
            let rightPatch = OutputPatch(
                patchNumber: patch.wrappedValue.patchNumber + 1, // Incrémenter le numéro de patch
                busType: patch.wrappedValue.busType,
                destination: patch.wrappedValue.destination.dropLast(2) + " R", // Ajouter le suffixe "R"
                monitorType: patch.wrappedValue.monitorType,
                isStereo: true,
                isFirstInStereoPair: false
            )
            if index == sharedViewModel.outputPatches.count - 1 || sharedViewModel.outputPatches[index + 1].isFirstInStereoPair {
                sharedViewModel.outputPatches.insert(rightPatch, at: index + 1)
            }
        } else {
            // Désactiver le mode stéréo
            patch.wrappedValue.isStereo = false
            if patch.wrappedValue.destination.hasSuffix(" L") {
                patch.wrappedValue.destination = String(patch.wrappedValue.destination.dropLast(2))
            }
            
            // Supprimer la sortie droite associée
            if let rightPatchIndex = sharedViewModel.outputPatches.firstIndex(where: {
                $0.patchNumber == patch.wrappedValue.patchNumber + 1 && !$0.isFirstInStereoPair
            }) {
                sharedViewModel.outputPatches.remove(at: rightPatchIndex)
            }
        }
        
        // Mettre à jour les numéros de patch et supprimer les suffixes "L" et "R" si nécessaire
        sharedViewModel.updatePatchNumbers()
    }
    
       func updatePatchNumbers() {
        var newPatchNumber = 1 // Commencer la numérotation à 1
        
           for index in sharedViewModel.outputPatches.indices {
            // Attribuer à chaque patch un nouveau numéro basé sur son ordre dans la liste
               sharedViewModel.outputPatches[index].patchNumber = newPatchNumber
            newPatchNumber += 1 // Incrémenter pour le prochain patch
        }
    }
    
       func findRightPatchIndex(for patch: OutputPatch) -> Int? {
        guard patch.isStereo && patch.isFirstInStereoPair else { return nil }
           return sharedViewModel.outputPatches.firstIndex {
            $0.patchNumber == patch.patchNumber &&
            $0.isStereo &&
            !$0.isFirstInStereoPair
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        sharedViewModel.outputPatches.move(fromOffsets: source, toOffset: destination)
        sharedViewModel.updatePatchNumbers()
        
        
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let patchToDelete = sharedViewModel.outputPatches[index]
            if patchToDelete.isStereo {
                // Trouver et supprimer également la paire stéréo
                if let pairIndex = sharedViewModel.outputPatches.firstIndex(where: { $0.patchNumber == patchToDelete.patchNumber && $0.id != patchToDelete.id }) {
                    sharedViewModel.outputPatches.remove(at: pairIndex)
                }
            }
        }
        sharedViewModel.outputPatches.remove(atOffsets: offsets)
        sharedViewModel.updatePatchNumbers()
    }
    
       func addStereoPatch(for monoPatch: OutputPatch) {
        let stereoPatch = OutputPatch(patchNumber: monoPatch.patchNumber + 1,
                                      busType: monoPatch.busType,
                                      destination: monoPatch.destination,
                                      monitorType: monoPatch.monitorType,
                                      isStereo: true)
           sharedViewModel.outputPatches.insert(stereoPatch, at: sharedViewModel.outputPatches.firstIndex(of: monoPatch)! + 1)
           sharedViewModel.updatePatchNumbers()
    }
    
       func removeStereoPatch(for stereoPatch: OutputPatch) {
           if let index = sharedViewModel.outputPatches.firstIndex(of: stereoPatch) {
            // Trouvez l'index du patch partenaire (le patch "frère" dans le couple stéréo)
               let partnerIndex = sharedViewModel.outputPatches.firstIndex { $0.patchNumber == stereoPatch.patchNumber && $0.id != stereoPatch.id }
            
            // Supprimez le patch stéréo spécifié
               sharedViewModel.outputPatches.remove(at: index)
            
            // Si un patch partenaire existe, mettez à jour son statut stéréo en `false`
            if let partnerIndex = partnerIndex {
                sharedViewModel.outputPatches[partnerIndex].isStereo = false
            }
            
            // Mettez à jour les numéros de patch après la suppression
               sharedViewModel.updatePatchNumbers()
        }
    }
    
       func addNewItem(isStereo: Bool = false) {
        withAnimation {
            let basePatchNumber = nextPatchNumber
            let newPatch = OutputPatch(patchNumber: basePatchNumber,
                                       busType: newBusType,
                                       destination: newDestination,
                                       monitorType: newMonitorType,
                                       isStereo: isStereo,
                                       location: "")
            sharedViewModel.outputPatches.append(newPatch)
            sharedViewModel.updatePatchNumbers()
            if isStereo {
                // Créer et ajouter la sortie droite pour une sortie stéréo
                let rightPatch = OutputPatch(patchNumber: basePatchNumber, // Même numéro de patch pour indiquer qu'ils font partie du même canal stéréo
                                             busType: newBusType,
                                             destination: newDestination + " R", // Ajouter " R" pour indiquer la droite
                                             monitorType: newMonitorType,
                                             isStereo: isStereo,
                                             location: "")
                sharedViewModel.outputPatches.append(rightPatch)
                updatePatchNumbers()

            }
        }
    }
}

