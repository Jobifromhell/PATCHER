import SwiftUI

struct OutputPatchView:  View {
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @Binding var outputPatches: [OutputPatch]
    @State   var availableDestinations: [String] = []
    @State   var newBusType: String = "BUS"
    @State   var newDestination: String = "DESTINATION"
    @State   var newMonitorType: String = "TYPE"
    @State   var showingClearConfirmation = false
    @State   var isStereoPrevious = false
    @State   var currentDestinationText: String = "DESTINATION"
    
    @State   var wedge: Wedge?
    @State   var iem: IEM?

    @StateObject private var stageViewModel = StageViewModel(audioPatches: [], outputPatches: [], stageElements: [])

    let monitorTypes = ["WEDGE", "IEM", "SIDE", "DRUM FILL", "DRUM SUB", "AUX","LINE","FULL RANGE", "PA"]
    let busTypes = ["AUX","CUE","MATRIX", "DIRECT OUT", "TIE LINE", "MIX"]
    
      var nextPatchNumber: Int {
        (outputPatches.last?.patchNumber ?? 0) + 1
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Button(action: {
                    self.addNewItem(isStereo: false)
                }) {
                    Label("Add an output", systemImage: "plus")
                }
                .frame(alignment: .center)
                .padding()
                Button("Clear all") {
                    showingClearConfirmation = true
                }
                .alert(isPresented: $showingClearConfirmation) {
                    Alert(
                        title: Text("Confirm"),
                        message: Text("Erase all Output Patch data?"),
                        primaryButton: .destructive(Text("Clear")) {
                            withAnimation {
                                outputPatches.removeAll()
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            HStack{
                Button("ADD WEDGE") {
                    loadWedgePreset()
                }
                Button("ADD IEM") {
                    loadIEMPreset()
                }
                Button("ADD SIDE") {
                    loadSidePreset()
                }
                Button("ADD MONITOR") {
                    loadMonitorPreset()
                }
                Button("ADD CUE") {
                    loadCuePreset()
                }
                Button("ADD MATRIX") {
                    loadMatrixPreset()
                }
                Button("ADD MASTER") {
                    loadMasterPreset()
                }
            }
            List {
                ForEach($outputPatches) { $patch in
                    HStack {
                        Button(action: { self.delete(at: IndexSet([outputPatches.firstIndex(of: patch)!])) }) {
                            Image(systemName: "xmark.circle")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Text("\(patch.patchNumber)").frame(width: 30)
                        //                        Text("Output Type:")
                        Picker("", selection: $patch.busType) {
                            ForEach(busTypes, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        // Afficher le Toggle "Stereo" seulement si le patch est le premier d'une paire stéréo
                                if $patch.isFirstInStereoPair.wrappedValue {
                                    Toggle("Stereo", isOn: $patch.isStereo)
                                        .onChange(of: patch.isStereo) { isStereo in
                                            handleStereoChange(for: $patch, isStereo: isStereo)
                                        }
                                } else {
                                    // Pour les secondes lignes des sorties stéréo, nous ne montrons rien ou nous montrons un Toggle désactivé
                                    Toggle("Stereo", isOn: .constant(false))
                                        .disabled(true) // Le Toggle est désactivé et ne peut pas être modifié
                                        .hidden() // Le Toggle est complètement caché dans l'UI
                                }
                        TextField("Destination", text: $patch.destination)
                            .textFieldStyle(.plain)
//                        if patch.isStereo {
//                        }
                        Picker("Type:", selection: $patch.monitorType) {
                            ForEach(monitorTypes, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                    }
                    
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
                .onDisappear()
            }
        }
        .navigationTitle("PATCHER")
        .frame(minWidth: 300, minHeight: 300)
    }
}
