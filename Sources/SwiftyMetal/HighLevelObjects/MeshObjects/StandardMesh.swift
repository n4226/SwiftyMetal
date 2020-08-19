import Foundation

public extension Mesh {
	static var quad: Mesh = { 
		let m = Mesh(verts: [
			.init(1, 1, 0),
			.init(-1, 1, 0),
			.init(-1, -1, 0),
			.init(1, -1, 0)
		], uvs: [
			.init(1,1),
			.init(0,1),
			.init(0,0),
			.init(1,0),
		], colors: [
			.init(1,0,0,1),
			.init(1, 1, 0.2, 1),
			.init(0,1,0,1),
			.init(0,0,1,1),
		], normals: [
			.init(0, 0, 1),
			.init(0, 0, 1),
			.init(0, 0, 1),
			.init(0, 0, 1),
		],tangents: [
			.init(0, 1, 0),
			.init(0, 1, 0),
			.init(0, 1, 0),
			.init(0, 1, 0),
		],bitangents: [
			.init(1, 0, 0),
			.init(1, 0, 0),
			.init(1, 0, 0),
			.init(1, 0, 0),
		], indicies: [[
			0,1,2,
			0,2,3,
			// back
			//			2,1,0,
			//			3,2,0
		]])
		return m
	}()

	static var doubleSidedQuad: Mesh = { 
		let m = Mesh(verts: [
			.init(1, 1, 0),
			.init(-1, 1, 0),
			.init(-1, -1, 0),
			.init(1, -1, 0),
			
			.init(1, 1, 0),
			.init(-1, 1, 0),
			.init(-1, -1, 0),
			.init(1, -1, 0)
		], uvs: [
			.init(1,1),
			.init(0,1),
			.init(0,0),
			.init(1,0),
			
			.init(1,1),
			.init(0,1),
			.init(0,0),
			.init(1,0),
		], colors: [
			.init(1,0,0,1),
			.init(1, 1, 0.2, 1),
			.init(0,1,0,1),
			.init(0,0,1,1),
			
			.init(1,0,0,1),
			.init(1, 1, 0.2, 1),
			.init(0,1,0,1),
			.init(0,0,1,1),
		], normals: [
			.init(0, 0, 1),
			.init(0, 0, 1),
			.init(0, 0, 1),
			.init(0, 0, 1),
			
			.init(0, 0, -1),
			.init(0, 0, -1),
			.init(0, 0, -1),
			.init(0, 0, -1),
		],tangents: [
			.init(0, 1, 0),
			.init(0, 1, 0),
			.init(0, 1, 0),
			.init(0, 1, 0),
			
			
			.init(0, 1, 0),
			.init(0, 1, 0),
			.init(0, 1, 0),
			.init(0, 1, 0),
		],bitangents: [
			.init(1, 0, 0),
			.init(1, 0, 0),
			.init(1, 0, 0),
			.init(1, 0, 0),
			
			.init(-1, 0, 0),
			.init(-1, 0, 0),
			.init(-1, 0, 0),
			.init(-1, 0, 0),
		], indicies: [[
			0,1,2,
			0,2,3,
			// back
			2,1,0,
			3,2,0
		]])
		return m
	}()
	
}
