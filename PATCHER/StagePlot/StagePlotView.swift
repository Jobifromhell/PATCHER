import SwiftUI
import AppKit

struct StagePlotView: View {
    @State var showingDetailForElement: StageElement?
    @GestureState private var dragOffset = CGSize.zero
    @State private var capturedImage: NSImage? = nil
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @ObservedObject var viewModel: StageViewModel
    @State private var clearAllConfirmation = false
    @State private var selectedElement: StageElement? = nil
    
    var body: some View {
        GeometryReader { geometry in
                   let stageCenterX = geometry.size.width / 2
                   let stageCenterY = geometry.size.height / 2
                   
                   // Calculez ici le facteur d'échelle basé sur geometry.size et les dimensions initiales de la scène
            let scaleX = geometry.size.width / viewModel.initialStageWidth
            let scaleY = geometry.size.height / viewModel.initialStageHeight
            let scale = min(scaleX, scaleY)

            VStack(spacing: 0) {
                HStack{
                    Text("Define stage area first!")
//                                    .padding(5)
                    Text("Double click Icon to edit/delete")
//                                        .padding(5)
                }
                .padding()
                HStack {
                    Text("Stage Width (cm)")
                    TextField("Stage Width", value: $viewModel.stageWidth, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)

                    Text("Stage Height (cm)")
                    TextField("Stage Height", value: $viewModel.stageHeight, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                }
                
                HStack{
                    Text("Show/Hide Elements :")
                    
                    //                    Toggle(isOn: Binding(
                    //                        get: { self.viewModel.categorySelections[.source] ?? false },
                    //                        set: { self.viewModel.categorySelections[.source] = $0 }
                    //                    )) {
                    //                        Text("Audio Sources")
                    //                    }
                    Toggle(isOn: Binding(
                        get: { self.viewModel.categorySelections[.source] ?? false },
                        set: { self.viewModel.categorySelections[.source] = $0 }
                    )) {
                        Text("Source")
                    }
                    Toggle(isOn: Binding(
                        get: { self.viewModel.categorySelections[.musician] ?? false },
                        set: { self.viewModel.categorySelections[.musician] = $0 }
                    )) {
                        Text("Musician")
                    }
                    Toggle(isOn: Binding(
                        get: { self.viewModel.categorySelections[.patchBox] ?? false },
                        set: { self.viewModel.categorySelections[.patchBox] = $0 }
                    )) {
                        Text("Patch Box")
                    }
                    
                    Toggle(isOn: Binding(
                        get: { self.viewModel.categorySelections[.powerOutlet] ?? false },
                        set: { self.viewModel.categorySelections[.powerOutlet] = $0 }
                    )) {
                        Text("16A")
                    }
                    
                    Toggle(isOn: Binding(
                        get: { self.viewModel.categorySelections[.wedge] ?? false },
                        set: { newValue in
                            self.viewModel.categorySelections[.wedge] = newValue
                            self.viewModel.categorySelections[.iem] = newValue
                            self.viewModel.categorySelections[.side] = newValue
                        }
                    )) {
                        Text("Monitor")
                    }
                    Button("Clear All") {
                        clearAllConfirmation = true
                    }
                    .padding()

                    .alert(isPresented: $clearAllConfirmation) {
                        Alert(
                            title: Text("Confirm"),
                            message: Text("Do you want to erase all StagePlot data?"),
                            primaryButton: .destructive(Text("Clear")) {
                                viewModel.clearAllStageElements() // Correct
                            },
                            secondaryButton: .cancel()
                        )
                    }

                }
                
                .padding(.bottom, 0)
                VStack {
                                   let elements = ElementType.allCases
                                   let halfwayPoint = elements.count / 2
                                   
                                   HStack {
                                       ForEach(Array(elements[0..<halfwayPoint]), id: \.self) { type in
                                           Button("\(type.rawValue)") {
                                               let position = CGPoint(x: viewModel.stageWidth / 2, y: viewModel.stageHeight / 2)
                                               viewModel.addElement(type, name: type.rawValue, at: position)
                                           }
                                       }
                                   }
//                                   .padding(.bottom, 5)
                                   
                                   HStack {
                                       ForEach(Array(elements[halfwayPoint...]), id: \.self) { type in
                                           Button("\(type.rawValue)") {
                                               let position = CGPoint(x: viewModel.stageWidth / 2, y: viewModel.stageHeight / 2)
                                               viewModel.addElement(type, name: type.rawValue, at: position)
                                           }
                                       }
                                   }
                               }
                ZStack {
                                   Rectangle()
                                       .fill(Color.gray.opacity(0.5))
                                       // Utilisez le facteur d'échelle pour ajuster la taille du rectangle
                                       .frame(width: viewModel.stageWidth * scale,
                                              height: viewModel.stageHeight * scale)
                                       // Centrez le rectangle dans la vue
                                       .position(x: stageCenterX, y: stageCenterY)
                                       .border(Color.black, width: 1)
                                   
                                   // Pour chaque élément de la scène, ajustez sa position et sa taille en utilisant scale
                    ForEach(viewModel.stageElements.filter { viewModel.categorySelections[$0.type] ?? false }, id: \.id) { element in
                        ElementView(element: Binding.constant(element), viewModel: viewModel, audioPatches: [], outputPatches: [])
                            // Ici, appliquez la logique de formatage à `element.patch` avant de l'afficher
                    

                            .scaleEffect(scale) // Appliquez le facteur d'échelle à l'élément
                        // Ajustez la position de l'élément en fonction du facteur d'échelle et centrez-le
                            .position(x: (element.position(stageWidth: viewModel.stageWidth, stageHeight: viewModel.stageHeight).x * scale) + (stageCenterX - (viewModel.stageWidth * scale / 2)),
                                      y: (element.position(stageWidth: viewModel.stageWidth, stageHeight: viewModel.stageHeight).y * scale) + (stageCenterY - (viewModel.stageHeight * scale / 2)))
                            .zIndex(Double(element.zIndex))
                            .onTapGesture {
                                self.showingDetailForElement = element                                   }
                    }
                }
                Spacer()
//                               .padding(5)
                           }
                           .onAppear()
                           .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
                           .scaledToFit()
                           .sheet(item: $showingDetailForElement) { detailElement in
                               ElementDetailView(element: $viewModel.stageElements.first(where: { $0.id == detailElement.id })!, viewModel: viewModel, audioPatches: [], outputPatches: [])
                           }

                       }
                   }
        

    func saveStagePlotIntoProject() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let saveURL = documentsDirectory.appendingPathComponent("SavedStagePlot.json")
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(viewModel.stageElements)
            try data.write(to: saveURL, options: [.atomicWrite])
            print("Stage plot saved successfully.")
        } catch {
            print("Failed to save stage plot: \(error)")
        }
    }
//    func showGroupDetails(group: String) {
//        let groupElements = sharedViewModel.elements(forGroup: group)
//    }
}



