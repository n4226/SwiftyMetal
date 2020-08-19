import Foundation
import simd

public typealias vector2 = SIMD2<Float>
public typealias vector3 = SIMD3<Float>
public typealias vector4 = SIMD4<Float>

public typealias vector2D = SIMD2<Double>
public typealias vector3D = SIMD3<Double>
public typealias vector4D = SIMD4<Double>

public extension vector3 {
	
	static var forward: vector3 {
		.init(0, 0, 1)
	}
	
	static var backward: vector3 {
		.init(0, 0, -1)
	}
	
	static var left: vector3 {
		.init(-1, 0, 0)
	}
	
	static var right: vector3 {
		.init(1, 0, 0)
	}
	
	static var up: vector3 {
		.init(0, 1, 0)
	}
	
	static var down: vector3 {
		.init(0, -1, 0)
	}
	
}
