//
//  HaredD.swift
//  PATCHER
//
//  Created by Olivier Jobin on 23/02/2024.
//

import Foundation
import SwiftUI


class SharedData: ObservableObject {
    @Published var selectedInputPatch: AudioPatch?
    // Ajoutez d'autres données partagées si nécessaire
}

