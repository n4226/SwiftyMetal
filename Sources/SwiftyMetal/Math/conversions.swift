import Foundation
import simd
import CoreGraphics

public extension FloatingPoint {
    //rad to deg
    var Degrees: Self {
        self * 180 / .pi
    }
    
    //deg to rad
    var Radians: Self {
        self * .pi / 180
    }
    
    
}

public extension Double {
    var float: Float {
        Float(self)
    }
    
    var cgfloat: CGFloat {
        CGFloat(self)
    }
    
    var int: Int {
        Int(self)
    }

}

public extension Float {
    var double: Double {
        Double(self)
    }
    
    var cgfloat: CGFloat {
        CGFloat(self)
    }
    
    var int: Int {
        Int(self)
    }
}

public extension CGFloat {
    var double: Double {
        Double(self)
    }
    var float: Float {
        Float(self)
    }
    
    var int: Int {
        Int(self)
    }
}

public extension FixedWidthInteger {
    var Degrees: Float {
        Float(self) * 180 / .pi
    }
    
    var Radians: Float {
        Float(self) * .pi / 180
    }
    
    var float: Float {
        Float(self)
    }
    
    var cgfloat: CGFloat {
        CGFloat(self)
    }
    
    var double: Double {
        Double(self)
    }
    
    var int: Int {
        Int(self)
    }
}

public extension vector2 {
    var vector64: vector2D {
        vector2D(self)
    }
    func convertTo3d(_ z: Float = 0)->vector3 {
        .init(self, z)
    }
}

public extension vector2D {
    var vector32: vector2 {
        vector2(self)
    }
    func convertTo3d(_ z: Double = 0)->vector3D {
        .init(self, z)
    }
}

public extension vector3 {
    var vector64: vector3D {
        vector3D(self)
    }
//    
//    var geo: vector3 {
//        math.LlatoGeo(lla: self.vector64).vector32
//    }
//    
//    var lla: vector3 {
//        math.GeotoLla(geo: self.vector64).vector32
//    }
    
    var withoutZ: vector2 {
        .init(x, y)
    }
}

public extension vector3D {
    var vector32: vector3 {
        vector3(self)
    }
    
//    var geo: vector3D {
//        math.LlatoGeo(lla: self)
//    }
//    
//    var lla: vector3D {
//        math.GeotoLla(geo: self)
//    }
    
    var withoutZ: vector2D {
        .init(x, y)
    }
}

public extension vector4 {
    var vector64: vector4D {
        vector4D(self)
    }
}

public extension vector4D {
    var vector32: vector4 {
        vector4(self)
    }
}

public extension CGPoint {
    var vector32: vector2 {
        vector2(x.float,y.float)
    }
    var vector64: vector2D {
        vector2D(x.double,y.double)
    }
}
