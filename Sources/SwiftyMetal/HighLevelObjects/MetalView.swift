import Foundation

#if canImport(SwiftUI)
import SwiftUI

#if canImport(UIKit)
@available(iOS 13.0,tvOS 13.0, *)
public struct MetalView: UIViewRepresentable {
	public init(scene: MetalScene, confic: NativeMetalView.Config) {
		self.scene = scene
		self.confic = confic
	}
	
	var scene: MetalScene
	var confic: NativeMetalView.Config
	
	public func makeUIView(context: Context) -> NativeMetalView {
		// NativeMetalView() will never throw
		let view = try! NativeMetalView(with: confic)
		view.scene = scene
		return view
	}
	
	public func updateUIView(_ uiView: NativeMetalView, context: Context) {
		
	}

}
#elseif canImport(Cocoa)
@available(OSX 10.15, *)
public struct MetalView: NSViewRepresentable {
	public init(scene: MetalScene, confic: NativeMetalView.Config) {
		self.scene = scene
		self.confic = confic
	}
	
	var scene: MetalScene
	var confic: NativeMetalView.Config
	
	public func makeNSView(context: Context) -> NativeMetalView {
		// NativeMetalView() will never throw
		let view = try! NativeMetalView(with: confic)
		view.scene = scene
		return view
	}
	
	public func updateNSView(_ nsView: NativeMetalView, context: Context) {
		
	}
	
}
#endif
#endif
