import Foundation
import Metal

/// Wrapes a mtllibrary
/// has a prefix varible which is prepended followed by an underscore when requesting functions from the library
open class Library: MetalRepresentable, Configurable {
	public typealias config = Config
	
    public struct Config: Configuration {
        public init(device: MTLDevice, prefix: String, bundle: Bundle = .main) {
            self.device = device
            self.prefix = prefix
            self.bundle = bundle
        }
        
		public var device: MTLDevice
		public var prefix: String
		public var bundle: Bundle = .main
	}
	
	public required init(with settings: Config) throws {
		prefix = settings.prefix
		mtlItem = try settings.device.makeDefaultLibrary(bundle: settings.bundle)
	}
	
	public let mtlItem: MTLLibrary
	public let prefix: String
	
	/// returns a function from the library with the name provide prepended by the prefix of the libbrary and an underscore
	///  - Parameters:
	///		- internalName: the name of the function in the mtllibrary after the prefix and an underscore
	open func function(named internalName: String)throws->MTLFunction {
		try mtlItem.makeFunction(name: "\(prefix)_\(internalName)", constantValues: MTLFunctionConstantValues())
	}
    
	public static func pbr(_ device: MTLDevice,bundle: Bundle = .main)throws->Library {
		try Library(with: Library.Config(device: device,prefix: "std_pbr", bundle: bundle))
    }
}
