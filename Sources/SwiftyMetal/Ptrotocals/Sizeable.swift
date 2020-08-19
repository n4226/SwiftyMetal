import Foundation
import simd
import SwiftyMetal_C

public protocol sizeable{}

public extension sizeable{
    static var size: Int{
        return MemoryLayout<Self>.size
    }
    
    static var stride: Int{
        return MemoryLayout<Self>.stride
    }
    
    static func size(_ count: Int)->Int{
        return MemoryLayout<Self>.size * count
    }
    
    static func stride(_ count: Int)->Int{
        return MemoryLayout<Self>.stride * count
    }
}

extension Uniforms: sizeable {}
extension UInt16: sizeable {}
extension UInt32: sizeable {}
extension UInt64: sizeable {}
extension simd_uchar16: sizeable {}
extension Int: sizeable{}
extension float4x4: sizeable {}
extension float3x3: sizeable {}
extension Float: sizeable {}
extension SIMD2: sizeable {}
extension SIMD3: sizeable {}
extension SIMD4: sizeable {}

