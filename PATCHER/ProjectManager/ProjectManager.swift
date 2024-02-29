import Foundation
import SwiftUI
import UniformTypeIdentifiers

class ProjectManager: ObservableObject {
    
    var sharedViewModel: SharedViewModel
    static let shared: ProjectManager = {
           let viewModel = SharedViewModel() // Create a default or shared instance
           return ProjectManager(sharedViewModel: viewModel)
       }()
    @Published var savedProjects: [Project] = []
    @Published var selectedProject: Project? {
        didSet {
            if let selectedProject = selectedProject {
                stageViewModel.load(from: selectedProject)
                sharedViewModel.audioPatches = selectedProject.audioPatches
                sharedViewModel.outputPatches = selectedProject.outputPatches
                sharedViewModel.stageElements = selectedProject.stageElements
            }
        }
    }

    var stageViewModel: StageViewModel = StageViewModel(audioPatches: [], outputPatches: [], stageElements: [])
    
     let projectsKey = "projects"
     let userDefaults = UserDefaults.standard
     let key = "SavedProjects"
    
    init(sharedViewModel: SharedViewModel) {
            self.sharedViewModel = sharedViewModel
            loadProjects()
            // Further initialization
        
        // Chargez les projets sauvegardés lors de l'initialisation
        if let encodedData = userDefaults.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                savedProjects = try decoder.decode([Project].self, from: encodedData)
            } catch {
                print("Error decoding projects: \(error.localizedDescription)")
            }
        }
    }
}



