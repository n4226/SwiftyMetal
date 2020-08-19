import Metal
import SwiftyMetal_C

public struct RenderRequestItem: Hashable {
	public init(mesh: MeshBuffers, originalMesh: Mesh, transform: TransformBuffer? = nil, transformData: [float4x4], firstTransform: Transform? = nil, materials: [PBRMaterialBuffer], originalMaterials: [PBRMaterial], pipeline: RenderPipelineState, count: Int = 1) {
		self.mesh = mesh
		self.originalMesh = originalMesh
		self.transform = transform
		self.transformData = transformData
		self.firstTransform = firstTransform
		self.materials = materials
		self.originalMaterials = originalMaterials
		self.pipeline = pipeline
		self.count = count
	}
	
	public init(device: MTLDevice,mesh: Mesh, transform: Transform, material: PBRMaterial, pipeline: RenderPipelineState)throws {
		self.mesh = try MeshBuffers(device, from: mesh, with: [])
		self.originalMesh = mesh
		self.transform = try TransformBuffer(device, from: transform, with: [])
		self.transformData = [transform.matrix]
		self.firstTransform = transform
		self.materials = [try PBRMaterialBuffer(device, material: material)]
		self.originalMaterials = [material]
		self.pipeline = pipeline
		self.count = 1
	}
	
    var mesh: MeshBuffers
    var originalMesh: Mesh
    var transform: TransformBuffer!
    var transformData: [float4x4]
    var firstTransform: Transform?
    
    var materials: [PBRMaterialBuffer]
    var originalMaterials: [PBRMaterial]
    var pipeline: RenderPipelineState
    var count: Int = 1
	
    public let id = UUID()
    
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	public static func ==(lhs: RenderRequestItem, rhs: RenderRequestItem) -> Bool {
		lhs.id == rhs.id
	}
	
    public mutating func buildTranform(scene: MetalScene)throws {
        if transform == nil || transform.transform.count != transformData.count {
            transform = nil
                transform = try TransformBuffer(scene.resourceDevice, from: transformData, with: [])
        }
    }
}
