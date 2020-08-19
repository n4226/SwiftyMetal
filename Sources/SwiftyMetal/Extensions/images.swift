import Foundation
import CoreGraphics

//public extension CGImage {
//    static func from(color: CGColor, size: CGSize = CGSize(width: 1, height: 1)) {
//        let context = CGContext(
//    } 
//}

#if canImport(UIKit)
import UIKit
public extension UIImage {
	convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		let rect = CGRect(origin: .zero, size: size)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		guard let cgImage = image?.cgImage else { return nil }
		self.init(cgImage: cgImage)
	}  
}
#elseif canImport(Cocoa)
import AppKit
public extension NSImage {
    convenience init(color: NSColor, size: NSSize) {
            self.init(size: size)
            lockFocus()
            color.drawSwatch(in: NSRect(origin: .zero, size: size))
            unlockFocus()
        }
    
    func asCg()->CGImage {
        var imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let imageRef = cgImage(forProposedRect: &imageRect, context: nil, hints: nil)!
        return imageRef
    }
}
#endif

