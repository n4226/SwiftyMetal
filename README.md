# SwiftGraphicsLib

A library with helpful objects to improve the experence of making an application with Metal on iOS, macOS, and tvOS in Swift. 

# Supported Operating-systems

`iOS 13+` `macOS 10.14+`  `macOS 10.14+ Catalyst` `tvOS 13+`

# Getting Started

You can use parts of the library on their own or all togerther.

To quickly get a project started, you can add a MetalView right inside your UIKit, AppKit, and SwiftUI views.

```swift
import SwiftUI
import SwiftyMetal

@main
struct SwiftyMetalDemoProjectApp: App {
	var scene = DemoScene()

	var body: some Scene {
		WindowGroup {
		if let scene = scene {
				MetalView(scene: scene, confic: .init())
			}
		}
	}
}
```

Then create a subclass of the MetalScene class.

```swift
public class DemoScene: MetalScene {

	var commandQueue: MTLCommandQueue!
	var meshBuffers: MeshBuffers!
	var transformBuffer: TransformBuffer!
	var transform: Transform!
	var pipeline: RenderPipelineState!

	public override func LoadScene() throws {
	commandQueue = try resourceDevice.makeCommandQueue().unWrapped()

	let mesh = Mesh.doubleSidedQuad
		meshBuffers = try MeshBuffers(resourceDevice, from: mesh, with: [])
		pipeline = try PBRPipelineState(device: resourceDevice)
		transform = Transform()
		transform.rotation = .init(angle: 0, axis: .up)
		transformBuffer = try TransformBuffer(resourceDevice, from: transform, with: [])
		cameraTransform.position.z = 4
	}

	public override func updateScene() {
		transform.rotation *= .init(angle: (90 * deltaTime.float).Radians, axis: .up)
		transformBuffer.update(from: transform)
	}

	public override func renderScene() throws {
		let descriptor = try renderingView.currentRenderPassDescriptor.unWrapped()

		let buffer = try commandQueue.makeCommandBuffer().unWrapped()

		let encoder = try buffer.makeRenderCommandEncoder(descriptor: descriptor).unWrapped()

		encoder.setRenderPipelineState(pipeline.mtlItem)
		meshBuffers.encodeVertexBuffers(in: encoder)
		encoder.setVertexBuffer(transformBuffer.transform.mtlItem, offset: 0, index: BufferIndex.modelTransform.rawValue)
		encoder.setVertexBuffer(resourceHolder.cameraUniforms.mtlItem, offset: 0, index: BufferIndex.uniforms.rawValue)

		encoder.drawIndexedPrimitives(type: .triangle, indexCount: meshBuffers.indexCount[0], indexType: .uint32, indexBuffer: meshBuffers.indicies[0].mtlItem, indexBufferOffset: 0)
		encoder.endEncoding()
		buffer.present(try renderingView.currentDrawable.unWrapped())
		buffer.commit()
	}
}
```

And, finally, create vertex and fragment shaders with the following names. See the SwiftyMetal-C section for more details on using the supplied header files.

```c++
#include <metal_stdlib>

using namespace metal;
#include <simd/simd.h>
#include "shaderTypes.h"
#include "argumentBuffers.h"

typedef struct
{
	float4 position [[position]];
	float4 color;
} ColorInOut;

vertex ColorInOut std_pbr_vertex(
								Vertex in [[stage_in]],
								constant matrix_float4x4 * model [[ buffer(BufferIndexModelTransform)]],
								constant Uniforms& uniforms [[buffer(BufferIndexUniforms)]]
								) {

	ColorInOut out;

	float4 position = float4(in.position,1);

	out.position = uniforms.projectionViewMatrix * *model * position;

	out.color = in.color;

	return out;
}

fragment float4 std_pbr_fragment(
								ColorInOut in [[stage_in]],
								constant PBRMaterial* material [[ buffer(BufferIndexMaterial)]],
								constant Uniforms& uniforms [[buffer(BufferIndexUniforms)]]
								) {
	return in.color;
}
```

# Some Features

## Wrapped Metal Objects

For all metal wrapped objects, the origonal metal object can be accessed with `.mtlItem`.

### Buffer

Buffers can be created from an array.

```swift
let buffer = try Buffer(device, from: [10,20,30])
```

Then they can be accessed or updated from the CPU

```swift
buffer.pointer // gives access to the pointer containing thedata
buffer.updatePointer(with: []) // updates the buffer
```

### Texture

### Heap

### PipelineState

### Library

### ArgumentBuffer

## High Level Objects

### Mesh

### PBRMaterial

an object to hold all the properties required by the PBRPipelineState

### PBRPipelineState

### Transform

### Scene

### Camera

calculates its projection matrix

### NativeMetalView

a subclass of MTKView with built in camera and reference to a scene

### MetalView

a NativeMetalView wrapped in a SwiftUI view

# SwiftyMetal-C

SwiftyMetal-C is a separate target which contains some constants that can be shared between CPU and GPU code to make life easier. If you would like to use these constants in your metal code, right now you must copy all the `.h` files into your project and import them in your `.metal` files. To access them in Swift, you must make sure that all the `.h` files are not included in your target. Then, import `SwiftyMetal-C` in your Swift files.
