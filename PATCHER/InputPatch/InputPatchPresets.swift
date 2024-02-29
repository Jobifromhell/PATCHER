//
//  InputPatchPresets.swift
//  StageOrganizerSwiftUI
//
//  Created by Olivier Jobin on 11/02/2024.
//

import SwiftUI

extension InputPatchView {
    func loadDrumKitPreset() {
        let currentMaxPatchNumber = sharedViewModel.audioPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let drumKitPreset: [AudioPatch] = [
            AudioPatch(patchNumber: currentMaxPatchNumber + 1, source: "BD IN", micDI: "B91", stand: "GROUND", phantom: true, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 2, source: "BD OUT", micDI: "B52", stand: "SMALL", phantom: false, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 3, source: "SN TOP", micDI: "B57", stand: "SMALL", phantom: false, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 4, source: "SN BOT", micDI: "SM57", stand: "SMALL", phantom: false, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 5, source: "SN 2", micDI: "SM57", stand: "SMALL", phantom: false, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 6, source: "HI HAT", micDI: "SM81", stand: "SMALL", phantom: true, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 7, source: "RACK TOM 1", micDI: "E604", stand: "CLAMP", phantom: false, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 8, source: "RACK TOM 2", micDI: "E604", stand: "CLAMP", phantom: false, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 9, source: "RACK TOM 3", micDI: "E604", stand: "CLAMP", phantom: false, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 10, source: "FLOOR TOM 1", micDI: "E604", stand: "CLAMP", phantom: false, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 11, source: "FLOOR TOM 2", micDI: "E604", stand: "CLAMP", phantom: false, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 12, source: "RIDE", micDI: "SM81", stand: "SMALL", phantom: true, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 13, source: "OH L", micDI: "C414", stand: "TALL", phantom: true, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 14, source: "OH R", micDI: "C414", stand: "TALL", phantom: true, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 15, source: "SPDS L", micDI: "DI", stand: "GROUND", phantom: true, location: "STAGE", group: "A"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 16, source: "SPDS R", micDI: "DI", stand: "GROUND", phantom: true, location: "STAGE", group: "A")
            
        ]
//        audioPatches.append(contentsOf:drumKitPreset)
        sharedViewModel.audioPatches.append(contentsOf: drumKitPreset)

    }
      func loadBassKitPreset() {
        let currentMaxPatchNumber = sharedViewModel.audioPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let bassKitPreset = [
            AudioPatch(patchNumber: currentMaxPatchNumber + 1, source: "BASS DI", micDI: "DI", stand: "GROUND", phantom: true, location: "STAGE", group: "B"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 2, source: "BASS MIC", micDI: "M88", stand: "SMALL", phantom: false, location: "STAGE", group: "B"),
        ]
//        audioPatches.append(contentsOf:bassKitPreset)
        sharedViewModel.audioPatches.append(contentsOf: bassKitPreset)
    }
    
      func loadGtrAmpKitPreset() {
        let currentMaxPatchNumber = sharedViewModel.audioPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let gtrampKitPreset = [
            AudioPatch(patchNumber: currentMaxPatchNumber + 1, source: "GTR AMP A", micDI: "SM57", stand: "SMALL", phantom: false, location: "STAGE", group: "C"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 2, source: "GTR AMP A", micDI: "MD421", stand: "SMALL", phantom: false, location: "STAGE", group: "C"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 3, source: "GTR AMP B", micDI: "SM57", stand: "SMALL", phantom: false, location: "STAGE", group: "D"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 4, source: "GTR AMP B", micDI: "MD421", stand: "SMALL", phantom: false, location: "STAGE", group: "D"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 5, source: "GTR DI 1", micDI: "DI", stand: "GROUND", phantom: true, location: "STAGE", group: "E"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 6, source: "GTR DI 2", micDI: "DI", stand: "GROUND", phantom: true, location: "STAGE", group: "F"),
            
        ]
//        audioPatches.append(contentsOf:gtrampKitPreset)
        sharedViewModel.audioPatches.append(contentsOf: gtrampKitPreset)

    }
      func loadKeyKitPreset() {
        let currentMaxPatchNumber = sharedViewModel.audioPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let keyKitPreset = [
            AudioPatch(patchNumber: currentMaxPatchNumber + 1, source: "KEY 1 LEFT", micDI: "DI", stand: "GROUND", phantom: true, location: "STAGE", group: "G"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 2, source: "KEY 1 RIGHT", micDI: "DI", stand: "GROUND", phantom: true, location: "STAGE", group: "G"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 3, source: "KEY 2 LEFT", micDI: "DI", stand: "GROUND", phantom: true, location: "STAGE", group: "G"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 4, source: "KEY 2 RIGHT", micDI: "DI", stand: "GROUND", phantom: true, location: "STAGE", group: "G")
        ]
//        audioPatches.append(contentsOf:keyKitPreset)
        sharedViewModel.audioPatches.append(contentsOf: keyKitPreset)
        
    }
      func loadVocalKitPreset() {
        let currentMaxPatchNumber = sharedViewModel.audioPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let vocalKitPreset = [
            AudioPatch(patchNumber: currentMaxPatchNumber + 1, source: "LEAD VOCAL", micDI: "SM58", stand: "ROUND BASE", phantom: false, location: "STAGE", group: "H"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 2, source: "BACKING VOCAL 1", micDI: "SM58", stand: "TALL", phantom: false, location: "STAGE", group: "I"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 3, source: "BACKING VOCAL 2", micDI: "SM58", stand: "TALL", phantom: false, location: "STAGE", group: "I"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 4, source: "BACKING VOCAL 3", micDI: "SM58", stand: "TALL", phantom: false, location: "STAGE", group: "I"),
            
        ]
//        audioPatches.append(contentsOf:vocalKitPreset)
        sharedViewModel.audioPatches.append(contentsOf: vocalKitPreset)
    }
      func loadHornSectionPreset() {
        let currentMaxPatchNumber = sharedViewModel.audioPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let hornSectionPreset = [
            AudioPatch(patchNumber: currentMaxPatchNumber + 1, source: "Trombone", micDI: "DPA 4099", stand: "SAX/TPT STC4099", phantom: true, location: "STAGE", group: "J"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 2, source: "Trumpet", micDI: "DPA4099", stand: "SAX/TPT STC4099", phantom: true, location: "STAGE", group: "J"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 3, source: "Sax Alto", micDI: "DPA4099", stand: "SAX/TPT STC4099", phantom: true, location: "STAGE", group: "J"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 4, source: "Sax Tenor", micDI: "MD421", stand: "TALL", phantom: false, location: "STAGE", group: "J"),
        ]
//        audioPatches.append(contentsOf:hornSectionPreset)
        sharedViewModel.audioPatches.append(contentsOf: hornSectionPreset)
    }
      func loadDjPreset() {
        let currentMaxPatchNumber = sharedViewModel.audioPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let djPreset = [
            AudioPatch(patchNumber: currentMaxPatchNumber + 1, source: "DJ LEFT", micDI: "DI", stand: "GROUND", phantom: true, location: "STAGE", group: "K"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 2, source: "DJ LEFT", micDI: "DI", stand: "GROUND", phantom: true, location: "STAGE", group: "K"),
            AudioPatch(patchNumber: currentMaxPatchNumber + 3, source: "DJ BOOTH", micDI: "DI", stand: "GROUND", phantom: true, location: "STAGE", group: "K"),
        ]
//        audioPatches.append(contentsOf:djPreset)
        sharedViewModel.audioPatches.append(contentsOf: djPreset)
    }
    
}
