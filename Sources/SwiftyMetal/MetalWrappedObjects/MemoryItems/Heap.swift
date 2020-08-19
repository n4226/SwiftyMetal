import Foundation
import Metal

public class Heap: MetalRepresentable, Configurable {
	
	public struct Config: Configuration {
		public init(size: Int,with resourceOptions: MTLResourceOptions,on device: MTLDevice) {
			self.size = size
			self.resourceOptions = resourceOptions
			self.device = device
		}
		
		public var size: Int
		/// only takes effect in ios 13+ and macos 10.15+
		public var resourceOptions: MTLResourceOptions
		public var device: MTLDevice
	}
	
	public required init(with settings: Config) throws {
		let des = MTLHeapDescriptor()
		
		des.size = settings.size
		if #available(OSX 10.15,iOS 13,tvOS 13, *) {
			des.resourceOptions = settings.resourceOptions
		} else {
		}
		
		mtlItem = try settings.device.makeHeap(descriptor: des).unWrapped()
	}
	
	public var mtlItem: MTLHeap
}
