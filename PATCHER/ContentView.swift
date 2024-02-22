//  ContentView.swift
//  StageOrganizerSwiftUI
//
//  Created by Olivier Jobin on 23/01/2024.
//

import SwiftUI
import CoreData
import AppKit

struct ContentView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @StateObject private var stageViewModel = StageViewModel(audioPatches: [], outputPatches: [], stageElements: [])
    @State private var selectedProject: Project? = nil
    @State private var currentProject: Project? = nil
    
        var audioPatches: [AudioPatch] {
            sharedViewModel.audioPatches
        }
    let sharedViewModel = SharedViewModel() // Créez une instance de SharedViewModel

    var body: some View {
        TabView {
            
            ProjectManagerView().tabItem {
                Label("PROJECT MANAGER", systemImage: "folder")
            }
            .frame(width: 400, height: 400) // Définissez la taille souhaitée pour la vue
            
            if let selectedProject = projectManager.selectedProject {
                InputPatchView(audioPatches: Binding(get: {
                    projectManager.selectedProject?.audioPatches ?? []
                }, set: { newPatches in
                    projectManager.selectedProject?.audioPatches = newPatches
                }) )
                .tabItem {
                    Label("INPUT PATCH", systemImage: "gear")
                }
                
                
                
                OutputPatchView(outputPatches: Binding(get: {
                    projectManager.selectedProject?.outputPatches ?? []
                }, set: { newPatches in
                    projectManager.selectedProject?.outputPatches = newPatches
                }) )
                .tabItem {
                    Label("OUTPUT PATCH", systemImage: "gear")
                }
                
                
                
                StagePlotView(viewModel: stageViewModel)
                
                    .tabItem {
                        Label("STAGEPLOT", systemImage: "gear")
                    }
                
                
                
                ExportView(audioPatches: projectManager.selectedProject?.audioPatches ?? [],
                           outputPatches: projectManager.selectedProject?.outputPatches ?? [],
                           stageElements: projectManager.selectedProject?.stageElements ?? [],
                           currentProject: $projectManager.selectedProject,
                           stageViewModel: stageViewModel)
                                    .environmentObject(SharedViewModel())
                                    .environmentObject(projectManager)

                .tabItem {
                    Label("EXPORT", systemImage: "square.and.arrow.up")
                }
            }
        }
        .onAppear {
            // Directly call captureView() on stageViewModel and assign the result
            //            let capturedImage = stageViewModel.captureView()
            //            // Convert NSImage to Image (SwiftUI) if needed for UI display
            //            self.stagePlotImage = capturedImage
            if let selectedProject = projectManager.selectedProject {
                stageViewModel.load(from: selectedProject)
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let projectManager = ProjectManager.shared
//        let sharedViewModel = SharedViewModel() // Ajoutez cette ligne pour créer une instance de SharedViewModel
//        return ContentView()
//            .environmentObject(projectManager)
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//            .environmentObject(sharedViewModel) // Ajoutez sharedViewModel à l'environnement
//        
//    }
//}
