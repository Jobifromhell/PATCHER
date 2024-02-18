import Foundation

enum ElementType: String, Codable, CaseIterable, Hashable {
    case riser4x3 = "Riser 4x3"
    case riser3x2 = "Riser 3x2"
    case riser2x2 = "Riser 2x2"
    case riser2x1 = "Riser 2x1"
    
    case source = "Source"
    case patchBox = "Patch"
    case powerOutlet = "16A"
    case musician = "Musician"
    
    case wedge = "Wedge"
    case iem = "IEM"
    case side = "SIDE"
//    case amplifier = "Amplifier"
//    case keys = "Keys"
}
