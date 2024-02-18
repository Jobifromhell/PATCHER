import Foundation

extension ProjectManager {
    func saveProject(_ project: Project) {
        savedProjects.append(project)
        saveProjectsToUserDefaults()
    }
    
    func getSavedProjects() -> [Project] {
        return savedProjects
    }
    
    func loadProjects() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        do {
            savedProjects = try JSONDecoder().decode([Project].self, from: data)
        } catch {
            print("Failed to decode projects: \(error)")
        }
    }
    
    
    func saveProjectsToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(savedProjects)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to encode projects: \(error)")
        }
    }
    
    
    func deleteProject(_ project: Project) {
        if let index = savedProjects.firstIndex(where: { $0.id == project.id }) {
            savedProjects.remove(at: index)
            saveProjectsToUserDefaults()
        }
    }
    
    func duplicateProject(_ newProject: Project) {
        // Ajouter le nouveau projet à la liste
        savedProjects.append(newProject)
        saveProjectsToUserDefaults()
        
        // Optionnel: Sélectionner automatiquement le nouveau projet
        selectedProject = newProject
    }
    func updateProject(_ project: Project, with newName: String) {
        if let index = savedProjects.firstIndex(where: { $0.id == project.id }) {
            savedProjects[index].projectName = newName
            saveProjectsToUserDefaults()
        }
    }
}
