import SwiftUI
import AppKit

struct StagePlotView: View {
    @State var showingDetailForElement: StageElement?
    @GestureState private var dragOffset = CGSize.zero
    @State private var capturedImage: NSImage? = nil
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @ObservedObject var viewModel: StageViewModel
    @State private var clearAllConfirmation = false
//    var elements: [StageElement]
//    @Binding var patchText: String

//
//        init(viewModel: StageViewModel) {
//            self.viewModel = viewModel
//        }
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
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
                    
                    // Confirmation pour effacer tous les éléments
                    .alert(isPresented: $clearAllConfirmation) {
                        Alert(
                            title: Text("Confirm"),
                            message: Text("Do you want to erase all StagePlot data?"),
                            primaryButton: .destructive(Text("Clear")) {
                                sharedViewModel.clearAllStageElements()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                
//                .padding()

                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: min(viewModel.stageWidth, geometry.size.width),
                                   height: min(viewModel.stageHeight, geometry.size.height))
                            .border(Color.black, width: 10)
                        if !viewModel.stageElements.isEmpty {
                            ForEach(viewModel.stageElements.filter { element in
                                viewModel.categorySelections[element.type] ?? false
                            }, id: \.id) { element in
                                ElementView(element: Binding.constant(element), viewModel: viewModel)
                                    .position(x: element.position(stageWidth: viewModel.stageWidth, stageHeight: viewModel.stageHeight).x,
                                              y: element.position(stageWidth: viewModel.stageWidth, stageHeight: viewModel.stageHeight).y)
                                    .zIndex(Double(element.zIndex))
                                    .onTapGesture {
                                        self.showingDetailForElement = element
                                    }
                            }
                        }
                }
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
                                   .padding(.bottom, 5)
                                   
                                   HStack {
                                       ForEach(Array(elements[halfwayPoint...]), id: \.self) { type in
                                           Button("\(type.rawValue)") {
                                               let position = CGPoint(x: viewModel.stageWidth / 2, y: viewModel.stageHeight / 2)
                                               viewModel.addElement(type, name: type.rawValue, at: position)
                                           }
                                       }
                                   }
                               }
                               .padding(5)
                           }
                           .onAppear()
                           .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
                           .scaledToFit()
                           .sheet(item: $showingDetailForElement) { detailElement in
                               ElementDetailView(element: $viewModel.stageElements.first(where: { $0.id == detailElement.id })!, viewModel: viewModel)
                           }
                       }
                   }
        
//    func saveStageElements(_ elements: [StageElement], to url: URL) {
//        do {
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(elements)
//            try data.write(to: url)
//            print("Sauvegarde réussie à \(url.path).")
//            print("Éléments sauvegardés : \(elements)")
//        } catch {
//            print("Échec de la sauvegarde des éléments de la scène : \(error)")
//        }
//    }
    

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




struct StagePlotView_Previews: PreviewProvider {
    
    static var previews: some View {
        StagePlotView(viewModel: StageViewModel())
        
    }
}
