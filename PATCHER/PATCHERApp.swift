//
//  StageOrganizerSwiftUIApp.swift
//  StageOrganizerSwiftUI
//
//  Created by Olivier Jobin on 23/01/2024.
//

import SwiftUI

@main
struct PATCHERApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var projectManager = ProjectManager.shared
//    @StateObject var sharedData = SharedData()
//    @StateObject var sharedViewModel = SharedViewModel()
    @State private var isImageShowing = true // Ajoutez cette ligne

    // Dans votre SceneDelegate.swift ou dans votre vue racine
    let sharedViewModel = SharedViewModel() // Créez une instance de SharedViewModel
   
    var body: some Scene {
           WindowGroup {
               ZStack {
                   // Votre ContentView principal
                   ContentView()
                       .environmentObject(projectManager)
                       .environment(\.managedObjectContext, persistenceController.container.viewContext)
                       .environmentObject(sharedViewModel)
                   
                   // L'image affichée au lancement de l'application
                   if isImageShowing {
                       Image("PATCHER1200")
                           .resizable()
                           .aspectRatio(contentMode: .fit)
//                           .transition(.opacity) // Animation de transition pour l'opacité lors de l'apparition
                           .animation(.easeInOut(duration: 2)) // Animation de disparition
                           .onAppear {
                               // Après un délai de 3 secondes, l'image disparaît
                               DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                   withAnimation {
                                       isImageShowing = false
                                   }
                               }
                           }
                   } else {
                       EmptyView() // Pour garder l'interface utilisateur propre lorsque l'image n'est plus affichée
                   }

               }
           }
       }
   }
