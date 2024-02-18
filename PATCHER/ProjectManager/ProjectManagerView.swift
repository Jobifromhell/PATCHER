import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ProjectManagerView: View {
    @State  var projectName: String = ""
    @State  var showSaveConfirmation = false
    @State  var loadedProject: Project?
    @State  var editingProjectName: String = ""
    @State  var isEditing: Bool = false
    @State  var editingProjectId: UUID?
    
    
    // Utilisez l'EnvironmentObject pour accéder à ProjectManager
    @EnvironmentObject var projectManager: ProjectManager
    
    // Liste des projets sauvegardés
//    @ObservedObject var savedProjects: ProjectManager = ProjectManager.shared
    
    var body: some View {
        VStack {
            TextField("Enter Project Name", text: $projectName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Create Project") {
                guard !projectName.isEmpty else { return }
                let newProject = Project(projectName: projectName, audioPatches: [], outputPatches: [], stageElements: [], creationDate: Date())
                projectManager.saveProject(newProject)
                // Charger immédiatement le projet nouvellement créé
                projectManager.selectedProject = newProject
                
                projectName = ""
                showSaveConfirmation = true
            }
            
            //            .alert(isPresented: $showSaveConfirmation) {
            //                Alert(title: Text("Project Saved"), message: Text("Your project has been saved successfully."), dismissButton: .default(Text("OK")))
            //            }
            
            //            Button("Check Saved Projects") {
            //                let savedProjects = projectManager.getSavedProjects()
            //                print("Saved Projects: \(savedProjects)")
            //            }
            //
            List(projectManager.getSavedProjects().sorted(by: { $0.creationDate > $1.creationDate })) { project in
                HStack {
                    if isEditing && editingProjectId == project.id {
                        TextField("Edit Project Name", text: $editingProjectName)
                    } else {
                        //                                Text(project.projectName)
                    }
                    //                            Spacer()
                    Button(action: {
                        if isEditing && editingProjectId == project.id {
                            // Save the edited name
                            projectManager.updateProject(project, with: editingProjectName)
                            isEditing = false
                            editingProjectId = nil
                        } else {
                            // Enable editing mode
                            editingProjectName = project.projectName
                            isEditing = true
                            editingProjectId = project.id
                        }
                    }) {
                        Image(systemName: isEditing && editingProjectId == project.id ? "checkmark.circle" : "pencil.circle")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Text(project.projectName)
                    Spacer()
                    Button(action: {
                        projectManager.selectedProject = project
                    }) {
                        Image(systemName: "arrow.right.circle").foregroundColor(.blue)
                    }
                    Button(action: {
                        projectManager.deleteProject(project)
                    }) {
                        Image(systemName: "xmark.circle").foregroundColor(.red)
                    }
                }
            }
        }
        .padding()
        .onAppear {
//             Chargez les projets sauvegardés lorsque la vue apparaît
            projectManager.loadProjects()
        }
    }
}
struct ProjectManagerView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectManagerView()
            .environmentObject(ProjectManager.shared)
        
    }
}
