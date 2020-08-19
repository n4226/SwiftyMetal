# SwiftGraphicsLib

A library with helpful objects to improve the experence of making an application with Metal on iOS, macOS, and tvOS in swift. 

# Supported Operating-systems

`iOS 13+` `macOS 10.14+`  `macOS 10.14+ Catalyst` `tvOS 13+`

# Getting Started

You can add a metal view right inside your SwiftUI views

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

Then create a subclass of the MetalScene class

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

# Some Features

## Wrapped Metal Objects

for all metal wrapped objects the origonal metal object can be accessed with `.mtlItem`

### Buffer

buffers can be created from an array

```swift
let buffer = try Buffer(device, from: [10,20,30])
```

than accessed or updated from the cpu

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

SwiftyMetal-C is a seperate target which containes some constants that can be shared between CPU and GPU code to make life easier. If you would like to use these constants in you metal code write now you must coppy all the `.h` files into your project and import them in your `.metal` files. To access them in swift you must make sure that all the `.h` files are not included in your target and import `SwiftyMetal-C` in you swift files.
