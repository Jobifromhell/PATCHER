//import Foundation
//
//// Extensions for StageElement
//extension StageElement {
//    // Function to calculate the absolute position based on the stage size
////    func position(stageWidth: CGFloat, stageHeight: CGFloat) -> CGPoint {
////        let x = stageWidth * positionXPercent
////        let y = stageHeight * positionYPercent
////        return CGPoint(x: x, y: y)
////    }
//    
////     Function to update zIndex based on ElementType
////    mutating func updateZIndex() {
////        switch type {
////        case .patchBox, .powerOutlet, .wedge, .iem:
////            zIndex = 1 // Scene elements displayed on top
////        default:
////            zIndex = 0 // Instruments and other elements displayed below
////        }
////    }
//}
//
//// Extensions for CGPoint and Angle to conform to Codable
////extension CGPoint/*: Codable*/ {
////    public init(from decoder: Decoder) throws {
////        var container = try decoder.unkeyedContainer()
////        let x = try container.decode(CGFloat.self)
////        let y = try container.decode(CGFloat.self)
////        self.init(x: x, y: y)
////    }
////    
////    public func encode(to encoder: Encoder) throws {
////        var container = /*try*/ encoder.unkeyedContainer()
////        try container.encode(x)
////        try container.encode(y)
////    }
////}
//
////extension Angle: Codable {
////    public init(from decoder: Decoder) throws {
////        let container = try decoder.singleValueContainer()
////        let degrees = try container.decode(Double.self)
////        self.init(degrees: degrees)
////    }
////    
////    public func encode(to encoder: Encoder) throws {
////        var container = /*try*/ encoder.singleValueContainer()
////        try container.encode(degrees)
////    }
////}
