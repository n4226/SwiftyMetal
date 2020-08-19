
#ifndef ShaderTypes_h
#define ShaderTypes_h

#ifdef __METAL_VERSION__
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#define NSInteger metal::int32_t
#else
#import <Foundation/Foundation.h>
#endif

#include <simd/simd.h>

typedef NS_ENUM(NSInteger, VertexAttribute)
{
	VertexAttributePosition  = 0,
	VertexAttributeColor  = 1,
	VertexAttributeUV  = 2,
	VertexAttributeNormal  = 3,
	VertexAttributeTangent  = 4,
	VertexAttributeBitangent  = 5,
};

typedef NS_ENUM(NSInteger, MatArgId)
{
	MatArgIdPipeline = 0,
	MatArgIdAlbedo = 1,
	MatArgIdMetallic = 2,
	MatArgIdNormal = 3,
	MatArgIdRoughness = 4,
	MatArgIdAo = 5,
	MatArgIdShadowMap = 6,
	MatArgIdUseColors = 7
};

typedef NS_ENUM(NSInteger, BufferIndex)
{
	BufferIndexMeshPositions  = 0,
	BufferIndexMeshGenerics   = 1,
	BufferIndexUniforms       = 13,
	BufferIndexMaterial       = 14,
	BufferIndexSubMesh        = 15,
	BufferIndexModelTransform = 16,
	BufferIndexModelTransformUpperLeft = 17,
};

typedef NS_ENUM(NSInteger, PostProcessingIndicies)
{
	PostProcessingIndiciesInput = 18,
	PostProcessingIndiciesOutput = 19,
};

typedef NS_ENUM(NSInteger, RenderTargetIndices)
{
	RenderTargetLighting  = 0,
	RenderTargetAlbedo    = 1,
	RenderTargetNormal    = 2,
	RenderTargetDepth     = 3,
	RenderTargetShadowDepth = 4
};

typedef struct
{
	matrix_float4x4 projectionViewMatrix;
	matrix_float4x4 projection_matrix_inverse;
	uint framebuffer_width;
	uint framebuffer_height;
} Uniforms;


#endif /* Header_h */
