import Foundation
import MetalKit

//#if canImport(UiKit)
//import UIKit

public class NativeMetalView: MTKView, Configurable, MTKViewDelegate {
	
	public struct Config: Configuration {
		public init(camera: Camera = Camera(fov: 60, nearClip: 0.1, farClip: 1000),clearColor: MTLClearColor? = nil, depthStencilPixelFormat: MTLPixelFormat? = nil, device: MTLDevice? = MTLCreateSystemDefaultDevice()) {
			self.camera = camera
			self.clearColor = clearColor
			self.depthStencilPixelFormat = depthStencilPixelFormat
			self.device = device
		}
		
		public var camera: Camera = Camera(fov: 60, nearClip: 0.1, farClip: 1000)
		/// if nil than the view will use the default: MTLClearColor(red: 0, green: 0, blue: 0.5, alpha: 1)
		public var clearColor: MTLClearColor? = nil
		/// if nil than the view will use the default: .depth16Unorm
		public var depthStencilPixelFormat: MTLPixelFormat? = nil
		
		/// the gpu that will render the view
		public var device: MTLDevice? = MTLCreateSystemDefaultDevice()
	}
	
	
	public required init(with settings: Config) throws {
		super.init(frame: .zero, device: (settings.device ?? MTLCreateSystemDefaultDevice()))
		update(with: settings)
	}
	
	public func update(with settings: Config) {
		device = settings.device
		delegate = self
		clearColor = settings.clearColor ?? MTLClearColor(red: 0, green: 0, blue: 0.5, alpha: 1)
		depthStencilPixelFormat = settings.depthStencilPixelFormat ?? MTLPixelFormat.depth32Float
		camera = settings.camera
		camera.view = self
	}
	
	required init(coder: NSCoder) {
		scene = nil
		super.init(coder: coder)
	}
	
	public var camera: Camera!
	public var scene: MetalScene?
	/// when this is true uniforms should be updated
	public var viewSizeDidChange = false
	
	public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
		viewSizeDidChange = true
	}
	
	public func draw(in view: MTKView) {
		scene?.updateAndRender(in: self)
	}
}
//#endif
