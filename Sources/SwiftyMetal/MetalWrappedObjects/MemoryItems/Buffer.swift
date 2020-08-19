import Foundation
import Metal
import simd

public class Buffer<contents: sizeable>: MetalRepresentable {
	
	
	/// if the buffer is private the data is not transfered to the buffer
	public init(_ device: MTLDevice, from array: [contents], with options: MTLResourceOptions = [], label: String? = nil) throws {
		count = array.count
		mtlItem = try device.makeBuffer(bytes: array, length: contents.size(count), options: options).unWrapped()
		if !options.contains(.storageModePrivate) {
			pointer = mtlItem.contents().bindMemory(to: contents.self, capacity: count)
		}
		mtlItem.label = label
	}
	
	/// if the buffer is private the data is not transfered to the buffer
	public init(_ heap: MTLHeap, from array: [contents], with options: MTLResourceOptions = [], label: String? = nil) throws {
		count = array.count
		
		mtlItem = try heap.makeBuffer(length: contents.size(count), options: options).unWrapped()
		if !options.contains(.storageModePrivate) {
			pointer = mtlItem.contents().bindMemory(to: contents.self, capacity: count)
			pointer.assign(from: array, count: count)
		}
		
		
		mtlItem.label = label
	}
	
	internal init(buffer: MTLBuffer,pointer: UnsafeMutablePointer<contents>, count: Int) {
		self.mtlItem = buffer
		self.pointer = pointer
		self.count = count
	}
	
	/// This is nil when the buffer is private
	public private(set) var pointer: UnsafeMutablePointer<contents>!
	
	/// This will not work when the buffer is private
	public func updatePointer(with array: [contents]) {
		count = array.count
		pointer.assign(from: array, count: count)
	}
    
	
	public let mtlItem: MTLBuffer
	public private(set) var count: Int
	
	public func EraseToAny()->AnyBuffer {
		return AnyBuffer(self)
	}
	
	public func copy()->Buffer<contents> {
		Buffer<contents>(buffer: mtlItem, pointer: pointer, count: count)
	}
	
}

public class AnyBuffer: MetalRepresentable {
	
	public init<T>(_ buffer: Buffer<T>) {
		mtlItem = buffer.mtlItem
		count = buffer.count
	}
	
	public var mtlItem: MTLBuffer
	public private(set) var count: Int
}
