import Foundation
import Metal
import ModelIO
import SwiftyMetal_C

public class Mesh: Hashable {
	public init(verts: [vector3] = .init(), uvs: [vector2] = .init(), colors: [vector4] = .init(), normals: [vector3] = .init(), tangents: [vector3] = .init(), bitangents: [vector3] = .init(), indicies: [[UInt32]] = .init()) {
		self.verts = verts
		self.uvs = uvs
		self.colors = colors
		self.normals = normals
		self.tangents = tangents
		self.bitangents = bitangents
		self.indicies = indicies
	}
	
	public var verts:      [vector3]
	public var uvs:        [vector2]
	public var colors:     [vector4]
	public var normals:    [vector3]
	public var tangents:   [vector3]
	public var bitangents: [vector3]
	public var indicies: [[UInt32]]
	
	public static func Coppying(_ original: Mesh, verts: [vector3]? = nil, uvs: [vector2]? = nil, colors: [vector4]? = nil, normals: [vector3]? = nil,tangents: [vector3]? = nil,bitangents: [vector3]? = nil, indicies: [[UInt32]]? = nil)->Mesh {
		let mesh = Mesh()
		
		if let verts = verts {
			mesh.verts = verts
		}
		else {
			mesh.verts = original.verts
		}
		if let uvs = uvs {
			mesh.uvs = uvs
		}
		else {
			mesh.uvs = original.uvs
		}
		if let colors = colors {
			mesh.colors = colors
		}
		else {
			mesh.colors = original.colors
		}
		if let indicies = indicies {
			mesh.indicies = indicies
		}
		else {
			mesh.indicies = original.indicies
		}
		if let normals = normals {
			mesh.normals = normals
		}
		else {
			mesh.normals = original.normals
		}
		if let tangents = tangents {
			mesh.tangents = tangents
		}
		else {
			mesh.tangents = original.tangents
		}
		if let bitangents = bitangents {
			mesh.bitangents = bitangents
		}
		else {
			mesh.bitangents = original.bitangents
		}
		return mesh
	}
	
	//    public private(set) lazy var MaxBound: Float = {
	//        FindBounds()
	//    }()
	
	public init(_ mesh: MDLMesh) {
		
		let posData = mesh.vertexAttributeData(forAttributeNamed: MDLVertexAttributePosition, as: .float3)!
		verts = Array(UnsafeBufferPointer(start: posData.dataStart.bindMemory(to: vector3.self, capacity: mesh.vertexCount), count: mesh.vertexCount))
		
		let uvData = mesh.vertexAttributeData(forAttributeNamed: MDLVertexAttributeTextureCoordinate, as: .float3)!
		uvs = Array(UnsafeBufferPointer(start: uvData.dataStart.bindMemory(to: vector2.self, capacity: mesh.vertexCount), count: mesh.vertexCount))
		
		let colorData = mesh.vertexAttributeData(forAttributeNamed: MDLVertexAttributeColor, as: .float3)
		if let colorData = colorData {
			colors = Array(UnsafeBufferPointer(start: colorData.dataStart.bindMemory(to: vector4.self, capacity: mesh.vertexCount), count: mesh.vertexCount))
		}
		else {
			colors = .init(repeating: vector4(0.4, 0, 0, 1), count: verts.count)
		}
		let normalData = mesh.vertexAttributeData(forAttributeNamed: MDLVertexAttributeNormal, as: .float3)!
		normals = Array(UnsafeBufferPointer(start: normalData.dataStart.bindMemory(to: vector3.self, capacity: mesh.vertexCount), count: mesh.vertexCount))
		
		let tangentData = mesh.vertexAttributeData(forAttributeNamed: MDLVertexAttributeTangent, as: .float3)!
		tangents = Array(UnsafeBufferPointer(start: tangentData.dataStart.bindMemory(to: vector3.self, capacity: mesh.vertexCount), count: mesh.vertexCount))
		
		let bitangentData = mesh.vertexAttributeData(forAttributeNamed: MDLVertexAttributeBitangent, as: .float3)!
		bitangents = Array(UnsafeBufferPointer(start: bitangentData.dataStart.bindMemory(to: vector3.self, capacity: mesh.vertexCount), count: mesh.vertexCount))
		
		indicies = []
		
		for sub in (mesh.submeshes as! [MDLSubmesh])[..<1] {
			print(sub.indexCount,sub.geometryType)
			indicies += [Array(UnsafeBufferPointer(start: sub.indexBuffer.map().bytes.bindMemory(to: UInt32.self, capacity: sub.indexCount), count: sub.indexCount))]
		}
		
	}
	
	public func hash(into hasher: inout Hasher) {
		return hasher.combine(ObjectIdentifier(self))
	}
	
	public static func == (lhs: Mesh, rhs: Mesh) -> Bool {
		return lhs === rhs
	}
	
	
	public func save(to url: URL)throws {
		let vertWrap = FileWrapper(regularFileWithContents: verts.withUnsafeBytes { pointer in
			Data(pointer)
		})
		
		let uvsWrap = FileWrapper(regularFileWithContents: uvs.withUnsafeBytes { pointer in
			Data(pointer)
		})
		
		let colorsWrap = FileWrapper(regularFileWithContents: colors.withUnsafeBytes { pointer in
			Data(pointer)
		})
		
		let normalsWrap = FileWrapper(regularFileWithContents: normals.withUnsafeBytes { pointer in
			Data(pointer)
		})
		
		let tangentsWrap = FileWrapper(regularFileWithContents: tangents.withUnsafeBytes { pointer in
			Data(pointer)
		})
		
		let bitangentsWrap = FileWrapper(regularFileWithContents: bitangents.withUnsafeBytes { pointer in
			Data(pointer)
		})
		
		let subMesheIndicies = (0..<indicies.count).map{(String($0),indicies[$0])}.reduce(into: [:]) {$0[$1.0] = FileWrapper(regularFileWithContents: $1.1.withUnsafeBytes { pointer in
			Data(pointer)
		})}
		let subMeshWrapper = FileWrapper(directoryWithFileWrappers: subMesheIndicies)
		
		
		let wrapper = FileWrapper(directoryWithFileWrappers: [
			"verts":    vertWrap,
			"uvs":      uvsWrap,
			"colors":   colorsWrap,
			"normals":  normalsWrap,
			"tangents":  tangentsWrap,
			"bitangents":  bitangentsWrap,
			"subMeshes": subMeshWrapper,
		])
		//        wrapper.icon = NSImage(systemSymbolName: "building.2.fill", accessibilityDescription: nil)
		//            if FileManager.default.fileExists(atPath: url.absoluteString) {
		try? FileManager.default.removeItem(at: url)
		//            }
		try wrapper.write(to: url, options: [], originalContentsURL: nil)
	}
	
	
	public static func load(from url: URL)throws->Mesh {
		let wrapper = try FileWrapper(url: url, options:[])
		
		let vertWrap     = try wrapper.fileWrappers.unWrapped() ["verts"]
		let uvsWrap      = try wrapper.fileWrappers.unWrapped() ["uvs"]
		let colorsWrap   = try wrapper.fileWrappers.unWrapped() ["colors"]
		let normalsWrap  = try wrapper.fileWrappers.unWrapped() ["normals"]
		let tangentsWrap  = try wrapper.fileWrappers.unWrapped() ["tangents"]
		let bitangentsWrap  = try wrapper.fileWrappers.unWrapped() ["bitangents"]
		let subMeshWrap  = try wrapper.fileWrappers.unWrapped() ["subMeshes"]
		//        let indiciesWrap = try wrapper.fileWrappers.unwrap() ["indicies"]
		
		let verts = try vertWrap.unWrapped().regularFileContents.unWrapped().withUnsafeBytes { (pointer) in
			Array(pointer.bindMemory(to: vector3.self))
		}
		
		let uvs = try uvsWrap.unWrapped().regularFileContents.unWrapped().withUnsafeBytes { (pointer) in
			Array(pointer.bindMemory(to: vector2.self))
		}
		
		let colors = try colorsWrap.unWrapped().regularFileContents.unWrapped().withUnsafeBytes { (pointer) in
			Array(pointer.bindMemory(to: vector4.self))
		}
		
		let normals = try normalsWrap.unWrapped().regularFileContents.unWrapped().withUnsafeBytes { (pointer) in
			Array(pointer.bindMemory(to: vector3.self))
		}
		
		let tangents = try tangentsWrap.unWrapped().regularFileContents.unWrapped().withUnsafeBytes { (pointer) in
			Array(pointer.bindMemory(to: vector3.self))
		}
		
		let bitangents = try bitangentsWrap.unWrapped().regularFileContents.unWrapped().withUnsafeBytes { (pointer) in
			Array(pointer.bindMemory(to: vector3.self))
		}
		
		//        let indicies = try indiciesWrap.unwrap().regularFileContents.unwrap().withUnsafeBytes { (pointer) in
		//            Array(pointer.bindMemory(to: uint32.self))
		//        }
		
		var subMeshes = [[UInt32]]()
		for item in try subMeshWrap.unWrapped().fileWrappers.unWrapped().sorted(by: {$0.key < $1.key}) {
			subMeshes.append(try item.value.regularFileContents.unWrapped().withUnsafeBytes { (pointer) in
				Array(pointer.bindMemory(to: UInt32.self))
			})
		}
		
		subMeshes.removeAll(where: {$0.isEmpty})
		
		return Mesh(verts: verts, uvs: uvs, colors: colors, normals: normals,tangents: tangents,bitangents: bitangents, indicies: subMeshes)
	}
	
	public static var vertexDescriptor: VertexDescriptor {
		VertexDescriptor({ (make) in
			make.createAttribute(format: .float3, attribute: VertexAttribute.position)
			make.createAttribute(format: .float4, attribute: VertexAttribute.color)
			make.createAttribute(format: .float2, attribute: VertexAttribute.UV)
			make.createAttribute(format: .float3, attribute: VertexAttribute.normal)
			make.createAttribute(format: .float3, attribute: VertexAttribute.tangent)
			make.createAttribute(format: .float3, attribute: VertexAttribute.bitangent)
			
			make.createLayout(stride: vector3.stride, attribute: VertexAttribute.position)
			make.createLayout(stride: vector4.stride, attribute: VertexAttribute.color)
			make.createLayout(stride: vector2.stride, attribute: VertexAttribute.UV)
			make.createLayout(stride: vector3.stride, attribute: VertexAttribute.normal)
			make.createLayout(stride: vector3.stride, attribute: VertexAttribute.tangent)
			make.createLayout(stride: vector3.stride, attribute: VertexAttribute.bitangent)
		})
	}
	
}

public struct MeshBuffers {
	public var vertCount: Int
	public var indexCount: [Int]
	public var verts: Buffer<vector3>
	public var uvs: Buffer<vector2>
	public var colors: Buffer<vector4>
	public var normals: Buffer<vector3>
	public var tangents: Buffer<vector3>
	public var bitangents: Buffer<vector3>
	public var indicies: [Buffer<UInt32>]
	
	
	public func buffers()->[AnyBuffer] {
		[
			verts.EraseToAny(),
			uvs.EraseToAny(),
			colors.EraseToAny(),
			normals.EraseToAny()
		] + indicies.map{$0.EraseToAny()}
	}
	
	public init(_ device: MTLDevice,from mesh: Mesh,with options: MTLResourceOptions,labelSufix: String? = nil)throws {
		// constants
		vertCount = mesh.verts.count
		indexCount = mesh.indicies.map(\.count)
		
		// buffers
		verts = try Buffer(device, from: mesh.verts, with: options,label: "verts " + (labelSufix ?? ""))
		uvs = try Buffer(device, from: mesh.uvs, with: options,label: "uvs "  + (labelSufix ?? ""))
		colors = try Buffer(device, from: mesh.colors, with: options,label: "colors " + (labelSufix ?? ""))
		normals = try Buffer(device, from: mesh.normals, with: options,label: "normals " + (labelSufix ?? ""))
		tangents = try Buffer(device, from: mesh.tangents, with: options,label: "tangents " + (labelSufix ?? ""))
		bitangents = try Buffer(device, from: mesh.bitangents, with: options,label: "bitangents " + (labelSufix ?? ""))
		indicies = []
		for i in 0..<mesh.indicies.count {
			indicies.append(try Buffer(device, from: mesh.indicies[i], with: options, label: "indicies \(i) " + (labelSufix ?? "")))
		}
	}
	
	public init(_ heap: MTLHeap,from mesh: Mesh,with options: MTLResourceOptions,labelSufix: String? = nil)throws {
		// constants
		vertCount = mesh.verts.count
		indexCount = mesh.indicies.map(\.count)
		
		// buffers
		verts = try Buffer(heap, from: mesh.verts, with: options,label: "verts")
		uvs = try Buffer(heap, from: mesh.uvs, with: options,label: "uvs")
		colors = try Buffer(heap, from: mesh.colors, with: options,label: "colors")
		normals = try Buffer(heap, from: mesh.normals, with: options,label: "normals")
		tangents = try Buffer(heap, from: mesh.tangents, with: options,label: "tangents " + (labelSufix ?? ""))
		bitangents = try Buffer(heap, from: mesh.bitangents, with: options,label: "bitangents " + (labelSufix ?? ""))
		indicies = []
		for i in 0..<mesh.indicies.count {
			indicies.append(try Buffer(heap, from: mesh.indicies[i], with: options, label: "indicies \(i)"))
		}
	}
	
	public mutating func update(from mesh: Mesh) {
		verts.updatePointer(with: mesh.verts)
		uvs.updatePointer(with: mesh.uvs)
		colors.updatePointer(with: mesh.colors)
		normals.updatePointer(with: mesh.normals)
		for i in 0..<indicies.count {
			indicies[i].updatePointer(with: mesh.indicies[i])
		}
	}
	
	// make sure that both MeshBuffers have the same length buffers and same number of submeshes
	public func coppy(to other: MeshBuffers, buffer: MTLCommandBuffer)throws {
		guard indicies.count == other.indicies.count else {
			return
		}
		
		let encoder = try buffer.makeBlitCommandEncoder().unWrapped()

		encoder.copy(
			from: verts.mtlItem, sourceOffset: 0,
			to: other.verts.mtlItem, destinationOffset: 0,
			size: verts.mtlItem.length)
		encoder.copy(
			from: uvs.mtlItem, sourceOffset: 0,
			to: other.uvs.mtlItem, destinationOffset: 0,
			size: uvs.mtlItem.length)
		encoder.copy(
			from: colors.mtlItem, sourceOffset: 0,
			to: other.colors.mtlItem, destinationOffset: 0,
			size: colors.mtlItem.length)
		encoder.copy(
			from: normals.mtlItem, sourceOffset: 0,
			to: other.normals.mtlItem, destinationOffset: 0,
			size: normals.mtlItem.length)
		encoder.copy(
			from: tangents.mtlItem, sourceOffset: 0,
			to: other.tangents.mtlItem, destinationOffset: 0,
			size: tangents.mtlItem.length)
		encoder.copy(
			from: bitangents.mtlItem, sourceOffset: 0,
			to: other.bitangents.mtlItem, destinationOffset: 0,
			size: bitangents.mtlItem.length)
		for i in 0..<indicies.count {
			encoder.copy(
				from: indicies[i].mtlItem, sourceOffset: 0,
				to: other.indicies[i].mtlItem, destinationOffset: 0,
				size: indicies[i].mtlItem.length)
		}


		encoder.endEncoding()
	}
	
	public func encodeVertexBuffers(in commandEncoder: MTLRenderCommandEncoder) {
		commandEncoder.setVertexBuffer(verts.mtlItem, offset: 0, index: VertexAttribute.position.rawValue)
		commandEncoder.setVertexBuffer(uvs.mtlItem, offset: 0, index: VertexAttribute.UV.rawValue)
		commandEncoder.setVertexBuffer(colors.mtlItem, offset: 0, index: VertexAttribute.color.rawValue)
		commandEncoder.setVertexBuffer(normals.mtlItem, offset: 0, index: VertexAttribute.normal.rawValue)
		commandEncoder.setVertexBuffer(tangents.mtlItem, offset: 0, index: VertexAttribute.tangent.rawValue)
		commandEncoder.setVertexBuffer(bitangents.mtlItem, offset: 0, index: VertexAttribute.bitangent.rawValue)
	}
	
}
