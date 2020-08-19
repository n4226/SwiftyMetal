import Foundation
import Metal

public protocol MetalRepresentable {
	associatedtype representedType
	
	var mtlItem: representedType {get}
}
