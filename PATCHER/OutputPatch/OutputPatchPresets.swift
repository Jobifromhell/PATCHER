import SwiftUI

extension OutputPatchView{
      func loadWedgePreset() {
        let currentMaxPatchNumber = outputPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let monoWedgePreset = [
            OutputPatch(patchNumber: currentMaxPatchNumber + 1, busType: "AUX", destination: "DRUM", monitorType: "WEDGE", isStereo: false),
        ]
        outputPatches.append(contentsOf: monoWedgePreset)
    }
      func loadIEMPreset() {
        let currentMaxPatchNumber = outputPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let monoIEMPreset = [
            OutputPatch(patchNumber: currentMaxPatchNumber + 1, busType: "AUX", destination: "LEAD", monitorType: "IEM", isStereo: false),
        ]
        outputPatches.append(contentsOf: monoIEMPreset)
    }
      func loadSidePreset() {
        let currentMaxPatchNumber = outputPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let monoSidePreset = [
            OutputPatch(patchNumber: currentMaxPatchNumber + 1, busType: "AUX", destination: "FRONT STAGE", monitorType: "FULL RANGE", isStereo: false),
        ]
        outputPatches.append(contentsOf: monoSidePreset)
    }
      func loadMonitorPreset() {
        let currentMaxPatchNumber = outputPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let monoMonitorPreset = [
            OutputPatch(patchNumber: currentMaxPatchNumber + 1, busType: "CUE", destination: "TECH", monitorType: "WEDGE", isStereo: false),
        ]
        outputPatches.append(contentsOf: monoMonitorPreset)
    }
      func loadCuePreset() {
        let currentMaxPatchNumber = outputPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let stereoCuePreset = [
            OutputPatch(patchNumber: currentMaxPatchNumber + 1, busType: "CUE", destination: "TECH", monitorType: "IEM", isStereo: false),
        ]
        outputPatches.append(contentsOf: stereoCuePreset)
    }
      func loadMasterPreset() {
        let currentMaxPatchNumber = outputPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let stereoMasterPreset = [
            OutputPatch(patchNumber: currentMaxPatchNumber + 1, busType: "MIX", destination: "PA", monitorType: "LINE", isStereo: false),
        ]
        outputPatches.append(contentsOf: stereoMasterPreset)
    }
      func loadMatrixPreset() {
        let currentMaxPatchNumber = outputPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let stereoMatrixPreset = [
            OutputPatch(patchNumber: currentMaxPatchNumber + 1, busType: "MATRIX", destination: "STEREO RECORD", monitorType: "LINE", isStereo: false),
        ]
        outputPatches.append(contentsOf: stereoMatrixPreset)
    }
}
