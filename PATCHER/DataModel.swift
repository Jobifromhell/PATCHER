//
//  Project.swift
//  StageOrganizerSwiftUI
//
//  Created by Olivier Jobin on 12/02/2024.
//

import SwiftUI
import AppKit

struct Project: Codable, Identifiable {
    var id = UUID()
    var projectName: String
    var audioPatches: [AudioPatch]
    var outputPatches: [OutputPatch]
    var stageElements: [StageElement]
    var creationDate: Date
}

struct AudioPatch: Identifiable, Codable, Equatable, Comparable, Hashable {
    var id: UUID = UUID()
    var patchNumber: Int
    var source: String
    var micDI: String
    var stand: String
    var phantom: Bool
    var clampAccessory: String?
    var location: String = ""
    var group: String

    
    static func < (lhs: AudioPatch, rhs: AudioPatch) -> Bool {
        lhs.patchNumber < rhs.patchNumber
    }
}

struct OutputPatch: Identifiable, Codable, Equatable, Comparable, Hashable {
    var id: UUID = UUID()
    var patchNumber: Int
    var busType: String
    var destination: String
    var monitorType: String
    var isStereo: Bool
    var location: String = ""
    var isFirstInStereoPair: Bool = true
    
    static func < (lhs: OutputPatch, rhs: OutputPatch) -> Bool {
        lhs.patchNumber < rhs.patchNumber
    }
}

// Model for StageElement that includes Codable conformance
struct StageElement: Identifiable, Codable, Equatable {
    var id: UUID /*= UUID()*/
//    let id: UUID
    var name: String
    var type: ElementType
    var positionXPercent: CGFloat
    var positionYPercent: CGFloat
    var rotation: Angle
    var patch: String
    var detail: String = ""
    var isSelected: Bool
    var zIndex: Int
    var group: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, positionXPercent, positionYPercent, rotation, patch, isSelected, zIndex
    }

    
    // Function to calculate the absolute position based on the stage size
    func position(stageWidth: CGFloat, stageHeight: CGFloat) -> CGPoint {
        let x = stageWidth * positionXPercent
        let y = stageHeight * positionYPercent
        return CGPoint(x: x, y: y)
    }
    
    // Function to update zIndex based on ElementType
    mutating func updateZIndex() {
        switch type {
        case .patchBox, .powerOutlet, .wedge, .iem:
            zIndex = 1 // Scene elements displayed on top
        default:
            zIndex = 0 // Instruments and other elements displayed below
        }
    }
}
// Extensions for CGPoint and Angle to conform to Codable
extension CGPoint/*: Codable*/ {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let x = try container.decode(CGFloat.self)
        let y = try container.decode(CGFloat.self)
        self.init(x: x, y: y)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = /*try*/ encoder.unkeyedContainer()
        try container.encode(x)
        try container.encode(y)
    }
}

extension Angle: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let degrees = try container.decode(Double.self)
        self.init(degrees: degrees)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = /*try*/ encoder.singleValueContainer()
        try container.encode(degrees)
    }
}
// Assuming CodableColor is used elsewhere and correctly defined
struct CodableColor: Codable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double
    
    init(color: Color) {
        // Simplified conversion from Color to RGBA components
        self.red = 0
        self.green = 0
        self.blue = 0
        self.alpha = 1
    }
    
    var color: Color {
        // Convert RGBA components back to Color
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}
struct Wedge {
    var output: String
    // Autres propriétés et méthodes
}

struct IEM {
    var output: String
    // Autres propriétés et méthodes
}
struct Side {
    var output: String
    // Autres propriétés et méthodes
}
