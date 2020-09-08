import Foundation
import Metal

public class ArgumentBuffer: MetalRepresentable {
	
	
	/// uses the device from the encoder object to create the needed buffers
	public convenience init<T: RawRepresentable>(function: MTLFunction,index: T, configure: (MTLArgumentEncoder)throws->(), options: MTLResourceOptions = [], label: String? = nil)throws where T.RawValue == Int {
		let encoder = function.makeArgumentEncoder(bufferIndex: index.rawValue)
		
		try self.init(encoder: encoder, configure: configure,options: options,label: label)
	}
    
    /// uses the device from the encoder object to create the needed buffers
    public convenience init<T: RawRepresentable>(function: MTLFunction,index: T,_ heap: MTLHeap, configure: (MTLArgumentEncoder)throws->(), options: MTLResourceOptions = [], label: String? = nil)throws where T.RawValue == Int {
        let encoder = function.makeArgumentEncoder(bufferIndex: index.rawValue)
        
        try self.init(encoder: encoder,heap, configure: configure,options: options,label: label)
    }
	
	public init(encoder: MTLArgumentEncoder, configure: (MTLArgumentEncoder)throws->(), options: MTLResourceOptions = [], label: String? = nil)throws {
		let device = encoder.device
		self.encoder = encoder
		mtlItem = try device.makeBuffer(length: encoder.encodedLength, options: options).unWrapped()
			encoder.setArgumentBuffer(mtlItem, offset: 0)
		mtlItem.label = label
		try configure(encoder)
	}
	
    public init(encoder: MTLArgumentEncoder,_ heap: MTLHeap, configure: (MTLArgumentEncoder)throws->(), options: MTLResourceOptions = [], label: String? = nil)throws {
        self.encoder = encoder
        mtlItem = try heap.makeBuffer(length: encoder.encodedLength, options: options).unWrapped()
            encoder.setArgumentBuffer(mtlItem, offset: 0)
        mtlItem.label = label
        try configure(encoder)
    }
    
	/// used for an arg buffers that is an element in an array in/of another arg buffer
	public init(arrayElementEncoder encoder: MTLArgumentEncoder,elements: Int, configure: (MTLArgumentEncoder)throws->(), options: MTLResourceOptions = [], label: String? = nil,setArgBuf: Bool = true)throws {
		let device = encoder.device
		self.encoder = encoder
		mtlItem = try device.makeBuffer(length: encoder.encodedLength * elements, options: options).unWrapped()
		mtlItem.label = label
		if setArgBuf {
			encoder.setArgumentBuffer(mtlItem, startOffset: 0, arrayElement: 0)
		}
		
		try configure(encoder)
	}
    
    /// used for an arg buffers that is an element in an array in/of another arg buffer
    public init(arrayElementEncoder encoder: MTLArgumentEncoder,_ heap: MTLHeap,elements: Int, configure: (MTLArgumentEncoder)throws->(), options: MTLResourceOptions = [], label: String? = nil,setArgBuf: Bool = true)throws {
        self.encoder = encoder
        mtlItem = try heap.makeBuffer(length: encoder.encodedLength * elements, options: options).unWrapped()
        mtlItem.label = label
        if setArgBuf {
            encoder.setArgumentBuffer(mtlItem, startOffset: 0, arrayElement: 0)
        }
        
        try configure(encoder)
    }
	
	public func encode(element: Int, config: (MTLArgumentEncoder)throws->()) rethrows {
		encoder.setArgumentBuffer(mtlItem, startOffset: 0, arrayElement: element)
		try config(encoder)
	}
	
	public let encoder: MTLArgumentEncoder
	public let mtlItem: MTLBuffer
}
