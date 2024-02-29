import SwiftUI

extension OutputPatchView{
      func loadWedgePreset() {
        let currentMaxPatchNumber = outputPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let monoWedgePreset = [
            OutputPatch(patchNumber: currentMaxPatchNumber + 1, busType: "AUX", destination: "DRUM", monitorType: "WEDGE", isStereo: false),
        ]
          sharedViewModel.outputPatches.append(contentsOf: monoWedgePreset)
          sharedViewModel.updatePatchNumbers()

    }
      func loadIEMPreset() {
        let currentMaxPatchNumber = outputPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let monoIEMPreset = [
            OutputPatch(patchNumber: currentMaxPatchNumber + 1, busType: "AUX", destination: "LEAD", monitorType: "IEM", isStereo: false),
        ]
          sharedViewModel.outputPatches.append(contentsOf: monoIEMPreset)
          sharedViewModel.updatePatchNumbers()

    }
      func loadSidePreset() {
        let currentMaxPatchNumber = outputPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let monoSidePreset = [
            OutputPatch(patchNumber: currentMaxPatchNumber + 1, busType: "AUX", destination: "FRONT STAGE", monitorType: "FULL RANGE", isStereo: false),
        ]
          sharedViewModel.outputPatches.append(contentsOf: monoSidePreset)
          sharedViewModel.updatePatchNumbers()

    }
      func loadMonitorPreset() {
        let currentMaxPatchNumber = outputPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let monoMonitorPreset = [
            OutputPatch(patchNumber: currentMaxPatchNumber + 1, busType: "CUE", destination: "TECH", monitorType: "WEDGE", isStereo: false),
        ]
          sharedViewModel.outputPatches.append(contentsOf: monoMonitorPreset)
          sharedViewModel.updatePatchNumbers()

    }
      func loadCuePreset() {
        let currentMaxPatchNumber = outputPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let stereoCuePreset = [
            OutputPatch(patchNumber: currentMaxPatchNumber + 1, busType: "CUE", destination: "TECH", monitorType: "IEM", isStereo: false),
        ]
          sharedViewModel.outputPatches.append(contentsOf: stereoCuePreset)
          sharedViewModel.updatePatchNumbers()

    }
      func loadMasterPreset() {
        let currentMaxPatchNumber = outputPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let stereoMasterPreset = [
            OutputPatch(patchNumber: currentMaxPatchNumber + 1, busType: "MIX", destination: "PA", monitorType: "LINE", isStereo: false),
        ]
          sharedViewModel.outputPatches.append(contentsOf: stereoMasterPreset)
          sharedViewModel.updatePatchNumbers()

    }
      func loadMatrixPreset() {
        let currentMaxPatchNumber = outputPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
        let stereoMatrixPreset = [
            OutputPatch(patchNumber: currentMaxPatchNumber + 1, busType: "MATRIX", destination: "STEREO RECORD", monitorType: "LINE", isStereo: false),
        ]
          sharedViewModel.outputPatches.append(contentsOf: stereoMatrixPreset)
          sharedViewModel.updatePatchNumbers()

    }
}
