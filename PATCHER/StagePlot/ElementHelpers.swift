import SwiftUI

func getShape(for type: ElementType?) -> AnyShape {
    guard let type = type else {
        return AnyShape(Rectangle()) // Fournir une forme par défaut en cas de nil
    }
    switch type {
    case /*.amplifier, .keys,*/.source, .wedge, .riser2x2, .riser3x2, .riser2x1, .riser4x3, .iem, .side:
        return AnyShape(RoundedRectangle(cornerRadius: 10))
    case  .patchBox, .musician, .powerOutlet :
        return AnyShape(Circle())
    }
}

func getColor(for type: ElementType?) -> Color {
    guard let type = type else {
        return .clear // Fournir une couleur par défaut en cas de nil
    }
    switch type {
    case .riser2x2, .riser3x2, .riser2x1, .riser4x3:
        return .gray
    case /*.amplifier, .keys,*/ .source:
        return . brown
    case .patchBox:
        return .orange
    case .powerOutlet:
        return .green
    case .musician:
        return .black
    case .iem, .wedge, .side:
        return .blue
    }
}

func getWidth(for type: ElementType) -> CGFloat {
    switch type {
    case .riser2x1:
        return 200
    case .riser4x3:
        return 400
    case .riser3x2:
        return 300
    case .riser2x2:
        return 200
//    case .amplifier:
//        return 100
//    case .keys:
//        return 120
    case .source, .musician:
        return 60
    case .patchBox:
        return 60
    case .powerOutlet:
        return 45
    case .wedge:
        return 70
    case .iem:
        return 45
    case .side:
        return 45
   
    }
}

func getHeight(for type: ElementType) -> CGFloat {
    switch type {
    case .riser2x1:
        return 100
    case .riser4x3:
        return 300
    case .riser2x2:
        return 200
    case .riser3x2:
        return 200
//    case .amplifier:
//        return 60
//    case .keys:
//        return 40
    case .source, .musician:
        return 60
    case .patchBox:
        return 45
    case .wedge:
        return 45
    case .iem, .powerOutlet:
        return 45
    case .side:
        return 80
    }
}
