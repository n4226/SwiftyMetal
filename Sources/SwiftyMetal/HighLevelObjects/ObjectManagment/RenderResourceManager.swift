
import Foundation
import Metal
import SwiftyMetal_C

public class RenderResourceManager {
    
    public init(scene: MetalScene)throws {
        self.scene = scene
    }
    
    
    public var name: String {"Render Resource Manager"}
    
    private weak var scene: MetalScene!
    
	/// will always have a value during a render view loop
    public var cameraUniforms: Buffer<Uniforms>!
	
	public var all = [RenderRequestItem]()
	
    public func updateUniforms(for view: NativeMetalView,with cameraTransform: Transform,cameraIndex: Int)throws {
		
		let viewMatrix: float4x4 =  cameraTransform.ViewMatrix
		let projectionMatrix = try view.cameras[cameraIndex].projection()
		let width = UInt32(view.drawableSize.width)
		let height = UInt32(view.drawableSize.height)
		
        if cameraUniforms == nil {
            
            
            var uniforms: Uniforms = .init()
            uniforms.projectionMatrix = projectionMatrix
            uniforms.viewMatrix = viewMatrix
            uniforms.projectionViewMatrix = projectionMatrix * viewMatrix
			uniforms.projection_matrix_inverse = projectionMatrix.inverse
            uniforms.framebuffer_height = height
            uniforms.framebuffer_width = width
            
            cameraUniforms = try Buffer(scene.resourceDevice, from: [uniforms], with: [], label: "Uniforms")
        }else {
			cameraUniforms!.pointer.pointee.projectionViewMatrix = projectionMatrix * viewMatrix
			cameraUniforms!.pointer.pointee.projection_matrix_inverse = projectionMatrix.inverse
			cameraUniforms!.pointer.pointee.framebuffer_height = height
			cameraUniforms!.pointer.pointee.framebuffer_width = width
            
            view.viewSizeDidChange = false
        }
    }
    
	public func add(request: RenderRequestItem) {
		all.append(request)
	}
    
}
