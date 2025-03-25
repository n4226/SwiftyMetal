
import Foundation
import simd

/// An abstract representation of a camera (all items in degrees)
open class Camera {
	public init(fov: Float, nearClip: Float, farClip: Float) {
		self.fov = fov
		self.nearClip = nearClip
		self.farClip = farClip
	}
	
	public weak var view: NativeMetalView?
	
	public let fov: Float
	public let nearClip: Float
	public let farClip: Float
	
	open func projection() throws->matrix_float4x4 {
		let view = try self.view.unWrapped()
		return matrix_perspective_right_hand(fovyRadians: fov.Radians, aspectRatio: view.drawableSize.width.float / view.drawableSize.height.float, nearZ: nearClip, farZ: farClip)
	}
    
    open func projection(width: Float, height: Float)->matrix_float4x4 {
        return matrix_perspective_right_hand(fovyRadians: fov.Radians, aspectRatio: width / height, nearZ: nearClip, farZ: farClip)
    }

	private static func sPlaneNormalize(_ inPlane: simd_float4)->simd_float4{
		inPlane / simd_length(simd_float3(inPlane.x,inPlane.y,inPlane.z));
	}
	
	public static func frustomPlanes(projection: matrix_float4x4,view: matrix_float4x4)throws->[vector4] {
		let transp_vpm = simd_transpose(projection * view)
		
		var planes = [vector4]()
		planes.reserveCapacity(6)
		
		planes[0] = sPlaneNormalize(transp_vpm.columns.3 + transp_vpm.columns.0)    // left plane eq
		planes[1] = sPlaneNormalize(transp_vpm.columns.3 - transp_vpm.columns.0)    // right plane eq
		planes[2] = sPlaneNormalize(transp_vpm.columns.3 + transp_vpm.columns.1)    // up plane eq
		planes[3] = sPlaneNormalize(transp_vpm.columns.3 - transp_vpm.columns.1)    // down plane eq
		planes[4] = sPlaneNormalize(transp_vpm.columns.3 + transp_vpm.columns.2)    // near plane eq
		planes[5] = sPlaneNormalize(transp_vpm.columns.3 - transp_vpm.columns.2)    // far plane eq

		return planes
	}
	
}
