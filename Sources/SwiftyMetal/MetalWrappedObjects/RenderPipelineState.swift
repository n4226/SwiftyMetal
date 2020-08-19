import Foundation
import Metal

public class RenderPipelineState: MetalRepresentable, Configurable, Equatable {
	
	public struct Config: Configuration {
		public init(library: Library, pipelineConfigurator: Configurator)throws {
			self.library = library
			self.descritpor = try CreatePipeline(configurator: pipelineConfigurator)
		}
		
		public var library: Library
		public var descritpor: MTLRenderPipelineDescriptor!
		
		public typealias Configurator = (MTLRenderPipelineDescriptor, Library)throws -> ()
		
		func CreatePipeline(configurator: Configurator)throws ->MTLRenderPipelineDescriptor {
			let pipelineDescriptor = MTLRenderPipelineDescriptor()
			
			try configurator(pipelineDescriptor,library)
			
			return pipelineDescriptor
		}
		
	}
	
	public required init(with settings: Config) throws {
		library = settings.library
		mtlItem = try library.mtlItem.device.makeRenderPipelineState(descriptor: settings.descritpor)
	}
	
	public let library: Library
	public var mtlItem: MTLRenderPipelineState
    
    public static func ==(lhs: RenderPipelineState,rhs: RenderPipelineState)->Bool {
        lhs === rhs
    }
	
}
