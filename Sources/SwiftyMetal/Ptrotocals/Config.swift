import Foundation

/// Used by an object that confoms to Configurable in order to pass options to that object
public protocol Configuration {
//	static func `default`()->Self
}
public extension Configuration {
}

public protocol Configurable {
	/// An object that can optionally be passed to the Configurable object's init method to configure it
	associatedtype config: Configuration
	init(with settings: config)throws
}
