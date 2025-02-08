import Foundation
import Metal

public class VertexDescriptor: MetalRepresentable {
	//MARK: Init
    public typealias configurator = (VertexDescriptor)->()
	
	public init(_ configurator: configurator) {
		mtlItem = MTLVertexDescriptor()
		configurator(self)
	}
	//MARK: Properties
	public var mtlItem: MTLVertexDescriptor
	
	//MAR: Helper Methods
	/// think of as element such as pos or uv
	public func createAttribute<VertexAttribute: RawRepresentable>(format: MTLVertexFormat,attribute: VertexAttribute) where VertexAttribute.RawValue == Int {
		mtlItem.attributes[attribute.rawValue].format = format
		mtlItem.attributes[attribute.rawValue].offset = 0
		mtlItem.attributes[attribute.rawValue].bufferIndex = attribute.rawValue
	}
	/// think of as buffer
	public func createLayout<VertexAttribute: RawRepresentable>(stride: Int,attribute: VertexAttribute)  where VertexAttribute.RawValue == Int {
		mtlItem.layouts[attribute.rawValue].stride = stride
		mtlItem.layouts[attribute.rawValue].stepRate = 1
		mtlItem.layouts[attribute.rawValue].stepFunction = .perVertex
	}
}
