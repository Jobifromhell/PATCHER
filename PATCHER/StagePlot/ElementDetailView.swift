import SwiftUI

struct ElementDetailView: View {
    @Binding var element: StageElement
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @ObservedObject var viewModel: StageViewModel
    @State private var patchText: String = ""
    
    
    var audioPatches: [AudioPatch]
    var outputPatches: [OutputPatch]
    
    init(element: Binding<StageElement>, viewModel: StageViewModel, audioPatches: [AudioPatch], outputPatches: [OutputPatch]) {
        self._element = element
        self.viewModel = viewModel
        self.audioPatches = audioPatches
        self.outputPatches = outputPatches
    }
    
    var isWedgeOrIEM: Bool {
        return element.type == .wedge || element.type == .iem || element.type == .side
    }
    
    var isAudioSource: Bool {
        return element.type == .source
    }
    
    var availableDestinations: [String] {
        if isWedgeOrIEM {
            return sharedViewModel.availableDestinations
        } else {
            return ["No available outpatch destination in SharedViewModel"]
        }
    }
    
    var body: some View {
        Form {
            TextField("Edit Name", text: $element.name)
            
            if isAudioSource {
                Picker("Group", selection: Binding(
                    get: { self.element.group ?? "" },
                    set: {
                        self.element.group = $0
                        sharedViewModel.selectedGroup = $0
                        print("Selected Group SharedViewModel: \(sharedViewModel.selectedGroup)")
                        handleSelectedGroup()
                        
                        // Update patch field when group changes
                        updatePatchField(forGroup: $0)
                    }
                )) {
                    ForEach(sharedViewModel.groupOptions, id: \.self) { group in
                        Text(group).tag(group)
                    }
                }
                .onChange(of: element.group) { newValue in
                    updatePatchField(forGroup: newValue)
                }
            }
            if isWedgeOrIEM {
                Picker("Destination", selection: $element.patch) {
                    ForEach(sharedViewModel.availableDestinations, id: \.self) { destination in
                        Text(destination)
                    }
                }
            }
            
            TextField("Detail", text: $element.detail)
            TextField("Patch", text: $patchText)
                .onAppear {
                    // Assurez-vous que cette partie récupère correctement les numéros de patch basés sur le groupe et les passe à la fonction de formatage
                    if let group = element.group, !group.isEmpty {
                        let patchNumbers = sharedViewModel.patchNumbers(forGroup: group) // Ceci devrait retourner un [Int]
                        // Formater les numéros de patch en intervalles et mettre à jour `patchText`
                        patchText = formatPatchNumbersAsIntervals(patchNumbers)
                    } else {
                        // Gérer le cas où le groupe est nul ou vide
                        patchText = "No patches"
                    }
                    
                    // Ajoutez des déclarations print() pour vérifier l'accessibilité des données
                    print("Selected Input Patch: \(sharedViewModel.selectedInputPatch?.patchNumber ?? -1)")
                    print("Available Output Destinations: \(sharedViewModel.availableOutputDestinations)")
                }

            Slider(value: $element.rotation.degrees, in: 0...360, step: 1) {
                Text("Rotation")
            }
            .accessibilityValue(Text("\(Int(element.rotation.degrees)) degrees"))
            
            Button("Bring to Front") {
                viewModel.bringElementToFront(element.id)
                presentationMode.wrappedValue.dismiss()
            }
            Button("Bring to Back") {
                viewModel.bringElementToBack(element.id)
                presentationMode.wrappedValue.dismiss()
            }
            Button("Save") {
                presentationMode.wrappedValue.dismiss()
            }
            
            Button("Delete", action: deleteElement)
                .foregroundColor(.red)
        }
        .onDisappear {
            // Handle saving element changes here
        }
        .navigationTitle("Edit Element")
        .padding()
    }
    
    private func formatPatchNumbersAsIntervals(_ patchNumbers: [Int]) -> String {
        guard !patchNumbers.isEmpty else { return "" }

        let sortedPatchNumbers = patchNumbers.sorted()
        var intervals = [(start: Int, end: Int)]()
        var currentInterval = (start: sortedPatchNumbers.first!, end: sortedPatchNumbers.first!)

        for patchNumber in sortedPatchNumbers.dropFirst() {
            if patchNumber - currentInterval.end > 1 {
                // Si le patchNumber actuel n'est pas consécutif, sauvegardez l'intervalle actuel et commencez-en un nouveau
                intervals.append(currentInterval)
                currentInterval = (start: patchNumber, end: patchNumber)
            } else {
                // Si le patchNumber est consécutif, mettez à jour la fin de l'intervalle actuel
                currentInterval.end = patchNumber
            }
        }
        // Ajoutez le dernier intervalle restant
        intervals.append(currentInterval)

        // Transformez les intervalles en chaînes de caractères
        let intervalStrings = intervals.map { interval -> String in
            if interval.start == interval.end {
                return "\(interval.start)"
            } else {
                return "\(interval.start)-\(interval.end)"
            }
        }

        return intervalStrings.joined(separator: ", ")
    }

    
    
    
    
    private func updatePatchField(forGroup group: String?) {
        guard let group = group, !group.isEmpty else { return }
        let patchNumbers = sharedViewModel.patchNumbers(forGroup: group)
        let patchString = patchNumbers.map(String.init).joined(separator: ", ")
        self.element.patch = patchString
    }
    
    private func deleteElement() {
        viewModel.stageElements.removeAll(where: { $0.id == element.id })
        presentationMode.wrappedValue.dismiss()
    }
    func handleSelectedGroup() {
        // Vérifie si `selectedGroup` contient une valeur
        if let group = sharedViewModel.selectedGroup {
            // Si `selectedGroup` n'est pas nulle, imprimez la valeur
            print("Le groupe sélectionné est : \(group)")
            // Ici, vous pouvez ajouter d'autres logiques spécifiques au groupe non nul
        } else {
            // Si `selectedGroup` est nulle, imprimez un message différent
            print("Aucun groupe n'a été sélectionné.")
        }
    }

}
