import Foundation
import Metal

open class MetalScene: Configurable {
	// MARK: Init and Config
	public typealias config = Config
	
	public struct Config: Configuration {
		public init(device: MTLDevice? = MTLCreateSystemDefaultDevice()) {
			self.device = device
		}
		
		public var device: MTLDevice? = MTLCreateSystemDefaultDevice()
	}
	
	public required init(with settings: Config) throws {
		// set local properties
		resourceDevice = try settings.device.unWrapped()
		resourceHolder = try RenderResourceManager(scene: self)
		
		// load scene if implemented by subclasses
		try LoadScene()
	}
	
	public convenience init?() {
		try? self.init(with: .init())
	}
	
	
	//MARK: Properties
	public var resourceHolder: RenderResourceManager!
	public var resourceDevice: MTLDevice
	/// this only has a value in the render loop for a view
	public private(set) var renderingView: NativeMetalView!
	public var cameraTransform: Transform = .init()
	private var lastFrameTime = Date()
	//MARK: Overide Methods
	
	/// overide this method in a subclass to progrmaticly create a scene right after the scene is initilized
	open func LoadScene()throws {
		
	}
	
	/// overide this method in a subclass to update a scene before rendering it
    open func updateScene() {
        
    }
	
	/// overide this method in a subclass to render a scene into the renderingView
	open func renderScene()throws {
        try resourceHolder.updateUniforms(for: renderingView, with: cameraTransform, cameraIndex: 0)
	}
    
	//MARK: Api
	public private(set) var deltaTime = 0.0
	public private(set) var time = 0.0
    
    public func render(in view: NativeMetalView) {
		renderingView = view
        do {
			try renderScene()
        } catch {
			print("Error (\(error)) while rendering a frame in view \(view). ")
        }
		renderingView = nil
    }
    
	public func updateAndRender(in view: NativeMetalView) {
		deltaTime = Date().timeIntervalSince(lastFrameTime)
		lastFrameTime = Date()
		time += deltaTime
        updateScene()
		render(in: view)
	}
}
