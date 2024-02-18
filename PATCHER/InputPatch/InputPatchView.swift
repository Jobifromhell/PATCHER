import SwiftUI

struct InputPatchView: View {
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @Binding var audioPatches: [AudioPatch] // Déclarez audioPatches comme une variable liée

    //    @EnvironmentObject var projectManager: ProjectManager

    let locationOptions = ["STAGE", "MON", "FOH", "OTHER"]
    @State var selectedLocation = "STAGE"
    @State var customLocation: String = ""
    @State var newInstrument: String = ""
    @State var newMic: String = ""
    @State var newMicStand: String = ""
    @State var newInsert: String = ""
    @State var isClampPickerVisible: Bool = false
    @State var newPhantom: Bool = false
    @State var showingClearConfirmation = false
    @State var selectedGroup = ""

    @StateObject private var stageViewModel = StageViewModel()

//       init(audioPatches: [AudioPatch]) { // Ajoutez cet initialiseur
//           self.audioPatches = audioPatches
//       }
    var nextPatchNumber: Int {
        (audioPatches.last?.patchNumber ?? 0) + 1
    }
        // Define fixed column widths
    let eraseButtonWidth: CGFloat = 40
    let groupPickerWidth: CGFloat = 50
    let patchNumberWidth: CGFloat = 50
    let sourceWidth: CGFloat = 100
    let micDIWidth: CGFloat = 100
    let standWidth: CGFloat = 100
    let phantomSwitchWidth: CGFloat = 70
    let locationPickerWidth: CGFloat = 100
    
    let standOptions = ["CLAMP", "SMALL", "TALL", "ROUND BASE", "GROUND","BRAS MAGIQUE", "CLAMP MOUNT CM4099", "CLIP DRUM DC4099", "CELLO CC4099","BASS BC4099", "ACCORDION AC4099", "GUITAR GC4099","LAVALIER STRING MHS6005", "PIANO PC4099", "SAX/TPT STC4099","UNIVERSAL  UC4099", "VIOLON/MANDOLIN VC4099"]
    
    let groupOptions = (65...90).map { String(UnicodeScalar($0)) }
    
    var body: some View {
        VStack {
            HStack {
                                TextField("New Instrument", text: $newInstrument)
                                TextField("New Mic", text: $newMic)
//                                TextField("New Mic Stand", text: $newMicStand)
                Button(action: addNewItem) {
//                    sharedViewModel.audioPatches[index] = updatedPatch
                    Label("Add an input", systemImage: "plus")
                }
                Button(action: sharedViewModel.updatePatchNumbers) {
                    Label("Refresh Patch", systemImage: "plus")
                }
                Button("Clear all") {
                    showingClearConfirmation = true
                }
                .frame(minWidth: 50, minHeight: 50)
                
                .alert(isPresented: $showingClearConfirmation) {
                    Alert(
                        title: Text("Confirm"),
                        message: Text("Erase all Input Patch data?"),
                        primaryButton: .destructive(Text("Clear")) {
                            withAnimation {
                                sharedViewModel.audioPatches.removeAll()
//                                audioPatches.removeAll()
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            HStack{
                
                Button("DRUM KIT") {
                    self.loadDrumKitPreset()
                }
                //                .padding()
                Button("BASS") {
                    self.loadBassKitPreset()
                }
                //                .padding()
                Button("GTR") {
                    self.loadGtrAmpKitPreset()
                }
                //                .padding()
                Button("KEY") {
                    self.loadKeyKitPreset()
                }
                //                .padding()
                Button("VOCALS") {
                    self.loadVocalKitPreset()
                }
                //                .padding()
                Button("HORNS") {
                    self.loadHornSectionPreset()
                }
                Button("DJ") {
                    self.loadDjPreset()
                }
            }
            HStack {
                Text("Erase").frame(width: eraseButtonWidth, alignment: .leading).fontWeight(.bold)
                Text("Group").frame(width: groupPickerWidth, alignment: .leading).fontWeight(.bold)
                Text("Patch").frame(width: patchNumberWidth, alignment: .leading).fontWeight(.bold)
                Text("Source").frame(width: sourceWidth, alignment: .leading).fontWeight(.bold)
                Text("Mic/DI").frame(width: micDIWidth, alignment: .leading).fontWeight(.bold)
                Text("Stand").frame(width: standWidth, alignment: .leading).fontWeight(.bold)
                Text("Phantom").frame(width: phantomSwitchWidth, alignment: .leading).fontWeight(.bold)
                Text("Location").frame(width: locationPickerWidth, alignment: .leading).fontWeight(.bold)
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.2))
            
            List {
                ForEach(audioPatches.indices, id: \.self) { index in
                    if index < sharedViewModel.audioPatches.count {
                        let patch = sharedViewModel.audioPatches[index]
                        HStack {
                            Button(action: { self.deleteItem(patch: patch) }) {
                                Image(systemName: "xmark.circle")
                            }
                            .frame(width: 35)
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Picker("", selection: $sharedViewModel.audioPatches[index].group) {
                                ForEach(groupOptions, id: \.self) { group in
                                    Text(group).tag(group as String?) // Cast explicite vers String
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 50)
                            .onChange(of: selectedGroup) { newValue in
                                updateGroupSelection(newGroup: newValue)
                            }
                            
                            Text("\(patch.patchNumber)").frame(width: 60)
                            TextField("Source", text: $sharedViewModel.audioPatches[index].source)
                            TextField("Mic/DI", text: $sharedViewModel.audioPatches[index].micDI)
                                .frame(width: 50)
                            Picker("", selection: $sharedViewModel.audioPatches[index].stand) {
                                ForEach(standOptions, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                            .pickerStyle(PopUpButtonPickerStyle())
                            Toggle("+48V", isOn: $sharedViewModel.audioPatches[index].phantom)
                            Picker("", selection: $sharedViewModel.audioPatches[index].location) {
                                ForEach(locationOptions, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                        }
                    }
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
                .navigationTitle("PATCHER")
            }


            }
        }
    func addNewItem() {
        withAnimation {
            let newPatch = AudioPatch(patchNumber: nextPatchNumber, source: newInstrument, micDI: newMic, stand: newMicStand, phantom: newPhantom, group: selectedGroup)
            audioPatches.append(newPatch)
            sharedViewModel.audioPatches.append(newPatch)

            // Assurez-vous que cette fonction met à jour correctement les numéros de patch dans sharedViewModel
            sharedViewModel.updatePatchNumbers()
            // Réinitialisation des champs après l'ajout
            newInstrument = ""
            newMic = ""
            newMicStand = ""
            newPhantom = false
            selectedGroup = "A"
            selectedLocation = "STAGE"
            let currentMaxPatchNumber = sharedViewModel.audioPatches.max(by: { $0.patchNumber < $1.patchNumber })?.patchNumber ?? 0
//            audioPatches.append(newPatch)
            sharedViewModel.audioPatches.append(newPatch)

//                  sharedViewModel.updatePatchNumbers()
             
        }
    }


    
    func move(from source: IndexSet, to destination: Int) {
        sharedViewModel.audioPatches.move(fromOffsets: source, toOffset: destination)
        // Mettre à jour les données de patch
        sharedViewModel.updatePatchNumbers() // Ajoutez cet appel
        
    }
    func delete(at offsets: IndexSet) {
        audioPatches.remove(atOffsets: offsets)
    }

//    func delete(offsets: IndexSet) {
//        sharedViewModel.audioPatches.remove(atOffsets: offsets)
//        sharedViewModel.updatePatchNumbers() // Ajoutez cet appel
//    }
    func deleteItem(patch: AudioPatch) {
        withAnimation {
            if let index = audioPatches.firstIndex(where: { $0.id == patch.id }) {
                /*sharedViewModel.*/audioPatches.remove(at: index)
                // Appel à la fonction pour mettre à jour les numéros de patch
                sharedViewModel.updatePatchNumbers()
            }
        }
    }

    func updatePatchNumbers() {
        // Parcours toutes les lignes d'entrée et met à jour les numéros de patch en fonction de l'ordre actuel
        for index in audioPatches.indices {
            sharedViewModel.audioPatches[index].patchNumber = index + 1
        }
        // Ajouter un print pour vérifier
        print("Patch numbers updated: \(audioPatches)")
    }



    func updateGroupSelection(newGroup: String) {
        sharedViewModel.selectedGroup = newGroup
    }
    
}

//
//struct InputPatchView_Previews: PreviewProvider {
//    static var previews: some View {
//        InputPatchView()
//    }
//}
