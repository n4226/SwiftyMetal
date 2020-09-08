import Foundation
import MetalKit
import SwiftyMetal_C

open class PBRMaterial {
    public init(device: MTLDevice, diffuse: Texture,normal: Texture? = nil, metallic: Texture, shininess: Texture, ao: Texture,useColors: Bool) {
        self.diffuse = diffuse
        self.metallic = metallic
        self.shininess = shininess
        self.ao = ao
        if let normal = normal {
            self.normal = normal
        }
        else {
            self.normal = try! Texture(device, color: CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), options: [:], label: "normal")
        }
        self.useColors = useColors
    }
    
	
    open var diffuse   : Texture //: vector3
    open var normal    : Texture
    open var metallic  : Texture //: Float
    open var shininess : Texture //: Float
    open var ao        : Texture //: Float
    open var useColors: Bool
    
    public var allTextures: [Texture] {
        [diffuse,metallic,shininess,ao]
    }
    
    open func pipelineState(device: MTLDevice)throws-> RenderPipelineState {
        try PBRPipelineState(device: device)
    }
	
    public static func metal(device: MTLDevice)throws->PBRMaterial {
        PBRMaterial(
            device: device, diffuse:
                try Texture(device, color: CGColor(red: 0.1, green: 0.5, blue: 0.1, alpha: 1), options: [:], label: "diffuse"),
            metallic:
                try Texture(device, color: CGColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1), options: [:], label: "metallic"),
            shininess:
                try Texture(device, color: CGColor(red: 1, green: 1, blue: 1, alpha: 1), options: [:], label: "shininess"),
            ao:
                try Texture(device, color: CGColor(red: 0, green: 0, blue: 0, alpha: 1), options: [:], label: "ao"), useColors: true)
//        PBRMaterial(diffuse: .init(0.1,0.5,0.1), metallic: 0.1, roughness: 0, ao: 0)
    }
       
    // metalic is speculare
    public static func loadAssets(device: MTLDevice, baseName: String)throws->PBRMaterial {
    //,diffuse: String,speculare: String, shininess: String, ao: String)
        PBRMaterial(device: device, diffuse:
                try Texture(device, assetName: baseName.appending("-diffuse")),
                     normal:
                try Texture(device, assetName: baseName.appending("-normal")),
            metallic:
                try Texture(device, assetName: baseName.appending("-specular")),
            shininess:
                try Texture(device, assetName: baseName.appending("-diffuse")),
            ao:
                try Texture(device, assetName: baseName.appending("-diffuse")), useColors: false
                    )
        
    }
    
}

extension PBRMaterial: ArgumentEncodable {
    public func encode(into encoder: MTLArgumentEncoder) throws {
        try encode(into: encoder, pipeline: pipelineState(device: encoder.device))
    }
    
    public func encode(into encoder: MTLArgumentEncoder, pipeline: RenderPipelineState?) throws {
        try encode(into: encoder, pipeline: pipeline ?? pipelineState(device: encoder.device))
    }
    
    public func encode(into encoder: MTLArgumentEncoder,pipeline: RenderPipelineState)throws {
		if #available(OSX 10.14,iOS 12,tvOS 12, *) {
			encoder.setRenderPipelineState(pipeline.mtlItem, index: MatArgId.pipeline.rawValue)
		}
        encoder.setTexture(diffuse.mtlItem, index: MatArgId.albedo.rawValue)
        encoder.setTexture(metallic.mtlItem, index: MatArgId.metallic.rawValue)
        encoder.setTexture(normal.mtlItem, index: MatArgId.normal.rawValue)
        encoder.setTexture(shininess.mtlItem, index: MatArgId.roughness.rawValue)
        encoder.setTexture(ao.mtlItem, index: MatArgId.ao.rawValue)
        encoder.constantData(at: MatArgId.useColors.rawValue).bindMemory(to: Bool.self, capacity: 1).pointee = useColors
	}
}

extension PBRMaterial: Hashable {
	
	// hashable and equatable compliance
	public static func == (lhs: PBRMaterial, rhs: PBRMaterial) -> Bool {
		lhs === rhs
	}
	
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(self))
	}
	
}

public class PBRMaterialBuffer {
    
    public init(_ device: MTLDevice,material: PBRMaterial,pipeline: RenderPipelineState? = nil)throws {
        buffer = try ArgumentBuffer(function: material.pipelineState(device: device).library.function(named: "fragment"), index: BufferIndex.material, configure: { (encoder) in
            try material.encode(into: encoder,pipeline: pipeline)
        }, options: [], label: "material")
    }
    
    init(_ heap: MTLHeap,material: PBRMaterial,pipeline: RenderPipelineState? = nil)throws {
        buffer = try ArgumentBuffer(function: material.pipelineState(device: heap.device).library.function(named: "fragment"),index: BufferIndex.material, heap, configure: { (encoder) in
            try material.encode(into: encoder,pipeline: pipeline)
        }, options: [], label: "material")
    }
    
    public var buffer: ArgumentBuffer
    
}


