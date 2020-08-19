import Foundation
import Metal

public class ComputePipelineState: MetalRepresentable, Configurable {
	
	public struct Config: Configuration {
		public init(library: Library, pipelineConfigurator: Configurator)throws {
			self.library = library
			self.descritpor = try CreatePipeline(configurator: pipelineConfigurator)
		}
		
		public var library: Library
		public var descritpor: MTLComputePipelineDescriptor!
		
		public typealias Configurator = (MTLComputePipelineDescriptor, Library)throws -> ()
		
		func CreatePipeline(configurator: Configurator)throws ->MTLComputePipelineDescriptor {
			let pipelineDescriptor = MTLComputePipelineDescriptor()
			
			try configurator(pipelineDescriptor,library)
			
			return pipelineDescriptor
		}
		
	}
	
	public required init(with settings: Config) throws {
		library = settings.library
		mtlItem = try library.mtlItem.device.makeComputePipelineState(descriptor: settings.descritpor,options: [], reflection: nil)
	}
	
	public let library: Library
	public var mtlItem: MTLComputePipelineState
	
}
