
#ifdef __METAL_VERSION__
#ifndef Header_h
#define Header_h

typedef struct {
	render_pipeline_state pipelinestate [[id(MatArgIdPipeline)]];
	
	texture2d<half,access::sample>  albedo [[id(MatArgIdAlbedo)]]; // float3
	texture2d<half,access::sample> metallic [[id(MatArgIdMetallic)]];
	texture2d<half,access::sample> normal [[id(MatArgIdNormal)]];
	texture2d<half,access::sample> roughness [[id(MatArgIdRoughness)]];
	texture2d<half,access::sample> ao [[id(MatArgIdAo)]];
	depth2d<float,access::sample> shadowMap    [[ id(MatArgIdShadowMap) ]];
	
	bool useColors [[ id(MatArgIdUseColors) ]];
		//    float
	
} PBRMaterial;

typedef struct {
	
	float3 albedo; // float3
	float metallic;
	float roughness;
	float ao;
	
} SampledPBRMaterial;

	// Raster order group definitions
#define LightingROG  0
#define GBufferROG   1

	// G-buffer outputs using Raster Order Groups
struct GBufferData
{
	half4 lighting        [[color(RenderTargetLighting), raster_order_group(AAPLLightingROG)]];
	half4 albedo_specular [[color(RenderTargetAlbedo),   raster_order_group(AAPLGBufferROG)]];
	half4 normal_shadow   [[color(RenderTargetNormal),   raster_order_group(AAPLGBufferROG)]];
	float depth           [[color(RenderTargetDepth),    raster_order_group(AAPLGBufferROG)]];
};

#endif /* Header_h */
#endif
