import Foundation
import SwiftUI
import UniformTypeIdentifiers

class ProjectManager: ObservableObject {
    @EnvironmentObject var sharedViewModel: SharedViewModel
    static let shared = ProjectManager()
    @Published var savedProjects: [Project] = []
    @Published var selectedProject: Project? {
        didSet {
            if let selectedProject = selectedProject {
                stageViewModel.load(from: selectedProject)
                NotificationCenter.default.post(name: Notification.Name("ProjectSelected"), object: nil, userInfo: ["project": selectedProject])
            }
        }
    }
    var stageViewModel: StageViewModel = StageViewModel(audioPatches: [], outputPatches: [], stageElements: [])
    
     let projectsKey = "projects"
     let userDefaults = UserDefaults.standard
     let key = "SavedProjects"
    
    
    init() {
        loadProjects()
        
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



