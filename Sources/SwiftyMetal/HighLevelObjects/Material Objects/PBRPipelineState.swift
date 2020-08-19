
import Metal
import SwiftyMetal_C


public class PBRPipelineState: RenderPipelineState {
	public init(device: MTLDevice,bundle: Bundle = .main)throws {
		let library = try Library.pbr(device,bundle: bundle)
		try super.init(with: RenderPipelineState.Config(library: library, pipelineConfigurator: { (des, _) in
			#if !os(tvOS)
			des.inputPrimitiveTopology = .triangle
			#endif
			
			des.colorAttachments[0].pixelFormat = .bgra8Unorm
			des.depthAttachmentPixelFormat = .depth32Float
			if #available(OSX 10.14,iOS 12,tvOS 12, *) {
				des.supportIndirectCommandBuffers = true
			} else {
				// Fallback on earlier versions
			}
			des.vertexFunction = try library.function(named: "vertex")
			des.fragmentFunction = try library.function(named: "fragment")
			
			des.vertexDescriptor = Mesh.vertexDescriptor.mtlItem
		}))
	}
	
	public required init(with settings: Config) throws {
		fatalError("init(with:) has not been implemented")
	}
}
