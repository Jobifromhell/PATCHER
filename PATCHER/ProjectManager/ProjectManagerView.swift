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
        
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var sharedViewModel : SharedViewModel
    @ObservedObject var savedProjects: ProjectManager = ProjectManager.shared
    
    var body: some View {
        VStack {
            if let selectedProjectName = projectManager.selectedProject?.projectName {
                           Text("Current Project: \(selectedProjectName)")
                               .font(.title)
                               .padding()
                               .opacity(50)
                       }
            TextField("Enter Project Name", text: $projectName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack{
                
                
                Button("Create Project") {
                    guard !projectName.isEmpty else { return }
                    let newProject = Project(projectName: projectName, audioPatches: [], outputPatches: [], stageElements: [], creationDate: Date())
                    projectManager.saveProject(newProject)
                    // Charger immédiatement le projet nouvellement créé
                    projectManager.selectedProject = newProject
                    
                    projectName = ""
                    showSaveConfirmation = true
                }
                
                .alert(isPresented: $showSaveConfirmation) {
                    Alert(title: Text("Project Saved"), message: Text("Let's go patching."), dismissButton: .default(Text("OK")))
                }
            }
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

