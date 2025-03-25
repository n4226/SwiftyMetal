import simd

public func transformMatrix(pos: vector3,scale: vector3,rot: simd_quatf)->matrix_float4x4 {
    .init(rows: [
        .init(1, 0, 0, pos.x),
        .init(0, 1, 0, pos.y),
        .init(0, 0, 1, pos.z),
        .init(0, 0, 0, 1),
    ])
		*
    .init(rot)
		*
    .init(rows: [
        .init(scale.x, 0, 0, 0),
        .init(0, scale.y, 0, 0),
        .init(0, 0, scale.z, 0),
        .init(0, 0, 0, 1),
    ])
}

public func ViewTransformMatrix(pos: vector3,scale: vector3,rot: simd_quatf)->matrix_float4x4 {
//	.init(rot)
//		*
//		.init(rows: [
//			.init(scale.x, 0, 0, 0),
//			.init(0, scale.y, 0, 0),
//			.init(0, 0, scale.z, 0),
//			.init(0, 0, 0, 1),
//		])
    .init(rot)
		*
		.init(rows: [
			.init(1, 0, 0, pos.x),
			.init(0, 1, 0, pos.y),
			.init(0, 0, 1, pos.z),
			.init(0, 0, 0, 1),
		])
}

public func matrix_perspective_right_hand(fovyRadians fovy: Float, aspectRatio: Float, nearZ: Float, farZ: Float) -> matrix_float4x4 {
	let ys = 1 / tanf(fovy * 0.5)
	let xs = ys / aspectRatio
	let zs = farZ / (nearZ - farZ)
	return matrix_float4x4.init(columns:(
		.init(xs,  0, 0,   0),
		.init( 0, ys, 0,   0),
		.init( 0,  0, zs, -1),
		.init( 0,  0, zs * nearZ, 0)))
}

public func matrix_ortho_left_hand(left: Float, right: Float, bottom: Float, top: Float, nearZ: Float, farZ: Float)->matrix_float4x4 {
    matrix_float4x4(rows:
        [SIMD4<Float>(2 / (right - left),                  0,                  0, (left + right) / (left - right)),
        SIMD4<Float>(0, 2 / (top - bottom),                  0, (top + bottom) / (bottom - top)),
        SIMD4<Float>(0,                  0, 1 / (farZ - nearZ),          nearZ / (nearZ - farZ)),
        SIMD4<Float>(0,                  0,                  0,                               1 )])
}

public func matrix_ortho_right_hand(left: Float, right: Float, bottom: Float, top: Float, nearZ: Float, farZ: Float)->matrix_float4x4 {
    matrix_float4x4(rows:
        [SIMD4<Float>(2 / (right - left),                  0,                  0, (left + right) / (left - right)),
        SIMD4<Float>(0, 2 / (top - bottom),                  0, (top + bottom) / (bottom - top)),
        SIMD4<Float>(0,                  0, -1 / (farZ - nearZ),          nearZ / (nearZ - farZ)),
        SIMD4<Float>(0,                  0,                  0,                               1 )])
}

public func matrix3x3_upper_left(_ m: float4x4)->float3x3 {
    let x = vector3(m.columns.0.x,m.columns.0.y,m.columns.0.z);
    let y = vector3(m.columns.1.x,m.columns.1.y,m.columns.1.z);
    let z = vector3(m.columns.2.x,m.columns.2.y,m.columns.2.z);
    return float3x3(x, y, z);
}
