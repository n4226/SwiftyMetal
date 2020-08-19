
import Foundation
import Metal
import simd

public struct Transform: Hashable {
	
	public init(position: vector3 = .zero, scale: vector3 = .one, rotation: simd_quatf = .init(from: .one, to: .one)) {
		self.position = position
		self.scale = scale
		self.rotation = rotation
	}
	
	public var position: vector3
	public var scale: vector3
	public var rotation: simd_quatf
    public var `static`: Bool = false
    public var instancedWith = [Transform]()
    
	public func hash(into hasher: inout Hasher) {
		hasher.combine(position)
		hasher.combine(scale)
		hasher.combine(rotation.vector)
		hasher.combine(`static`)
		hasher.combine(instancedWith)
	}
	
	public var matrix: float4x4 {
		transformMatrix(pos: position, scale: scale, rot: rotation)
	}
	
	public var ViewMatrix: float4x4 {
		ViewTransformMatrix(pos: -position, scale: scale, rot: rotation.inverse)
//        transformMatrix(pos: -position, scale: scale, rot: rotation.inverse)
	}
	
	public mutating func Look(at point: vector3,from direction: vector3 = .forward) {
		rotation = .init(from: normalize(direction), to: normalize(position - point))
	}
	
	public var forward: vector3 {
		rotation.act(vector3.forward)
	}
	
	public var backward: vector3 {
		rotation.act(vector3.backward)
	}
	
	public var left: vector3 {
		rotation.act(vector3.left)
	}
	
	public var right: vector3 {
		rotation.act(vector3.right)
	}
	
	public var up: vector3 {
		rotation.act(vector3.up)
	}
	
	public var down: vector3 {
		rotation.act(vector3.down)
	}
	
	public static var blank: Transform {
		Transform()
	}
}

public struct TransformBuffer {
    
	public init(_ device: MTLDevice,from pos: Transform,with options: MTLResourceOptions)throws {
		transform = try Buffer(device, from: [pos.matrix], with: options, label: "transform")
	}
	
	public init(_ heap: MTLHeap,from pos: Transform,with options: MTLResourceOptions)throws {
		transform = try Buffer(heap, from: [pos.matrix], with: options, label: "transform")
	}
    
    public init(_ device: MTLDevice,from pos: [Transform],with options: MTLResourceOptions)throws {
        transform = try Buffer(device, from: pos.map{$0.matrix}, with: options, label: "transform")
    }
    
    public init(_ heap: MTLHeap,from pos: [Transform],with options: MTLResourceOptions)throws {
        transform = try Buffer(heap, from: pos.map{$0.matrix}, with: options, label: "transform")
    }
    
    public init(_ device: MTLDevice,from pos: [float4x4],with options: MTLResourceOptions)throws {
        transform = try Buffer(device, from: pos, with: options, label: "transform")
    }
    
    public init(_ heap: MTLHeap,from pos: [float4x4],with options: MTLResourceOptions)throws {
        transform = try Buffer(heap, from: pos, with: options, label: "transform")
    }
	
	public mutating func update(from pos: Transform) {
		transform.updatePointer(with: [pos.matrix])
	}
    
	
	public func coppy(to other: TransformBuffer, buffer: MTLCommandBuffer)throws {
		
		let encoder = try buffer.makeBlitCommandEncoder().unWrapped()
		
		encoder.copy(
			from: transform.mtlItem, sourceOffset: 0, 
			to: other.transform.mtlItem, destinationOffset: 0, 
			size: transform.mtlItem.length)
		
		encoder.endEncoding()
	}
	// fix this
	public init(setPrivateTransform pos: Transform, buffer: MTLCommandBuffer,device: MTLDevice, heap: MTLHeap)throws {
		let blt = try buffer.makeBlitCommandEncoder().unWrapped()
		let inter = try Buffer(device, from: [pos.matrix], with: [], label: "transform private")
		
		self.transform = inter//try Buffer(heap, from: [pos.matrix], with: [.storageModePrivate], label: "transforms")
//		blt.copy(from: inter.item, sourceOffset: 0, to: transform.item, destinationOffset: 0, size: inter.item.length)
		
		blt.endEncoding()
	}
	
	public var transform: Buffer<float4x4>
}
/*
extension TransformBuffer: ArgumentEncodable {
	/// into a model buffer
	public func encode(into encoder: MTLArgumentEncoder) throws {
		encoder.setBuffer(transform.item, offset: 0, index: ModelArgId.transform.rawValue)
	}
}
*/
