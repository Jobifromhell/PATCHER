import SwiftUI

struct ElementDetailView: View {
    @Binding var element: StageElement
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @ObservedObject var viewModel: StageViewModel
    @State private var patchText: String = ""

    var isWedgeOrIEM: Bool {
        return element.type == .wedge || element.type == .iem
    }

    var isAudioSource: Bool {
        return element.type == .source
    }

    var availableDestinations: [String] {
        if isWedgeOrIEM {
            return sharedViewModel.outputPatchDestinations
        } else {
            return ["Default Destination 1", "Default Destination 2"]
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
                    ForEach(availableDestinations, id: \.self) { destination in
                        Text(destination)
                    }
                }
            }

            TextField("Detail", text: $element.detail)
            TextField("Patch", text: $patchText)
                .onAppear {
                    patchText = formatPatchNumbersForGroup(element.group)
                }
            Slider(value: $element.rotation.degrees, in: 0...360, step: 1) {
                Text("Rotation")
            }
            .accessibilityValue(Text("\(Int(element.rotation.degrees)) degrees"))

            Button("Bring to Front") {
                viewModel.bringElementToFront(element.id)
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
    
    private func formatPatchNumbersForGroup(_ group: String?) -> String {
        guard let group = group else { return "" }
        
        // Obtenez les numéros de patch pour le groupe donné à partir de sharedViewModel
        let patchNumbers = sharedViewModel.patchNumbers(forGroup: group)
        
        // Triez les numéros de patch dans l'ordre croissant
        let sortedPatchNumbers = patchNumbers.sorted()
        
        // Formatez les numéros de patch sous forme de chaîne séparée par des virgules
        let patchNumbersString = sortedPatchNumbers.map(String.init).joined(separator: ", ")
        
        return patchNumbersString
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
}
