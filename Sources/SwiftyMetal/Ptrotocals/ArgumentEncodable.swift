import Foundation
import Metal

public protocol ArgumentEncodable {
	func encode(into encoder: MTLArgumentEncoder)throws
}

