import Foundation
import MetalKit

public class Texture: MetalRepresentable {
    
//    / if the texture is private the data is not transfered to the buffer
    public init(_ device: MTLDevice,type: Type,format: MTLPixelFormat, usage: MTLTextureUsage, with options: MTLResourceOptions = [],maxMipMap: Int? = nil, label: String? = nil) throws {
        let descriptor = Texture.makeDescriptor(type: type, format: format, usage: usage, with: options, maxMipMap: maxMipMap)
        
        mtlItem = try device.makeTexture(descriptor: descriptor).unWrapped()
        mtlItem.label = label
    }
    
    public init(_ device: MTLDevice,_ descriptor: MTLTextureDescriptor, label: String? = nil) throws {
        mtlItem = try device.makeTexture(descriptor: descriptor).unWrapped()
        mtlItem.label = label
    }
    
    public init(_ heap: MTLHeap,_ descriptor: MTLTextureDescriptor, label: String? = nil) throws {
        mtlItem = try heap.makeTexture(descriptor: descriptor).unWrapped()
        mtlItem.label = label
    }
    
//    / if the texture is private the data is not transfered to the buffer
    public init(_ heap: MTLHeap,type: Type,format: MTLPixelFormat, usage: MTLTextureUsage, with options: MTLResourceOptions = [],maxMipMap: Int? = nil, label: String? = nil) throws {
        let descriptor = Texture.makeDescriptor(type: type, format: format, usage: usage, with: options, maxMipMap: maxMipMap)
        
        mtlItem = try heap.makeTexture(descriptor: descriptor).unWrapped()
        mtlItem.label = label
    }
    
    public init(_ device: MTLDevice,label: String? = nil,creator: (MTKTextureLoader)throws->(MTLTexture))rethrows {
        
        let loader = MTKTextureLoader(device: device)
        mtlItem = try creator(loader)
        mtlItem.label = label
    }
    
	#if canImport(UIKit)
	public convenience init(_ device: MTLDevice, assetName: String,scaleFactor: CGFloat = 2,bundle: Bundle = .main,options: [MTKTextureLoader.Option : Any] = [:], label: String? = nil)throws {
	try self.init(device) { creator in
	try creator.newTexture(name: assetName, scaleFactor: scaleFactor, bundle: bundle, options: options)
	}
	}
	#elseif canImport(Cocoa)
    public convenience init(_ device: MTLDevice, assetName: String,scaleFactor: CGFloat = 2,displayGamut: NSDisplayGamut = .sRGB,bundle: Bundle = .main,options: [MTKTextureLoader.Option : Any] = [:], label: String? = nil)throws {
        try self.init(device) { creator in
            try creator.newTexture(name: assetName, scaleFactor: scaleFactor, displayGamut: displayGamut, bundle: bundle, options: options)
        }
    }
	#endif
    
    public convenience init(_ device: MTLDevice,color: CGColor,options: [MTKTextureLoader.Option : Any] = [:], label: String? = nil)throws {
        try self.init(device,label: label) { creator in
            try creator.newTexture(texture: MDLTexture(data: withUnsafeBytes(of: SIMD4<Float>(x: color.components![0].float, y: color.components![1].float, z: color.components![2].float, w: color.components![3].float), {Data($0)}), topLeftOrigin: false, name: nil, dimensions: vector_int2(1,1), rowStride: 4 * 4, channelCount: 4, channelEncoding: .float32, isCube: false),options: options)
//            try creator.newTexture(cgImage: image, options: options)
        }
    }
    
//    public static func from<T>(_ device: MTLDevice,color: T,usage: MTLTextureUsage,format: MTLPixelFormat, label: String? = nil)throws->Texture where T: SIMD {
//        let text = try Texture(device, type: .type2D(size: SIMD2<Int>(1,1)), format: format, usage: usage, with: [.storageModeManaged], maxMipMap: 1, label: label)
//        
//        withUnsafeBytes(of: color) { (pointer) in
//            text.setContents(with: pointer.baseAddress!, bytePerRow: pointer.count)
//        }
//        
//        
//        return text
//    }
    
    public static func makeDescriptor(type: Type,format: MTLPixelFormat, usage: MTLTextureUsage, with options: MTLResourceOptions,maxMipMap: Int?)->MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        
        descriptor.resourceOptions = options
        descriptor.pixelFormat = format
        descriptor.usage = usage
        
//        descriptor.width = size.x
//        descriptor.height = size.y
//        descriptor.depth = size.z
//        descriptor.textureType = .
        descriptor.textureType = type.metalType!
        switch type {
        case .type1D(let size):
            descriptor.width = size
        case .type1DArray(let size, let count):
            descriptor.width = size
            descriptor.arrayLength = count
        case .type2D(let size):
            descriptor.width = size.x
            descriptor.height = size.y
        case .type2DArray(let size, let count):
            descriptor.width = size.x
            descriptor.height = size.y
            descriptor.arrayLength = count
        case .type2DMultisample(let size, let count):
            descriptor.width = size.x
            descriptor.height = size.y
//            descriptor.arrayLength = count
            //not done
        case .type2DMultisampleArray(let size, let count):
            descriptor.width = size.x
            descriptor.height = size.y
            descriptor.arrayLength = count
        case .type3D(let size):
            descriptor.width = size.x
            descriptor.height = size.y
            descriptor.depth = size.z
        case .typeCube(let size):
            descriptor.width = size.x
            descriptor.height = size.y
        case .typeCubeArray(let size, let count):
            descriptor.arrayLength = count
        case .typeTextureBuffer(let size):
            descriptor.width = size
        }
        
        let heightLevels = ceil(log2(descriptor.width.double)).int
        let widthLevels = ceil(log2(descriptor.height.double)).int
        let depthLevels = ceil(log2(descriptor.depth.double)).int
        let mipCount = max(min(heightLevels,widthLevels,depthLevels),1)
        descriptor.mipmapLevelCount = min(mipCount,maxMipMap ?? 1)
        
        return descriptor
    }
    
    /// if reagon is nil than it is set to the whole texture
    public func setContents(in region: MTLRegion? = nil,mipMap: Int = 0,with bytes: UnsafeRawPointer,bytePerRow: Int,bytesPerImage: Int = 0) {
        let region = region ?? MTLRegion(origin: MTLOrigin(x: 0, y: 0, z: 0), size: MTLSize(width: mtlItem.width, height: mtlItem.height, depth: mtlItem.depth))
        mtlItem.replace(region: region, mipmapLevel: mipMap, slice: 0, withBytes: bytes, bytesPerRow: bytePerRow, bytesPerImage: bytesPerImage)
    }
    
    
    
    public var mtlItem: MTLTexture
 
    public enum `Type` {
        case type1D(size: Int)

        case type1DArray(size: Int,count: Int)

        case type2D(size: SIMD2<Int>)

        case type2DArray(size: SIMD2<Int>,count: Int)
        // not sure what this neads yet
        case type2DMultisample(size: SIMD2<Int>,count: Int)

        case typeCube(size: SIMD2<Int>)

        @available(OSX 10.11, *)
        case typeCubeArray(size: SIMD2<Int>,count: Int)

        case type3D(size: SIMD3<Int>)
        
        // not sure what this neads yet
        @available(OSX 10.14, *)
        case type2DMultisampleArray(size: SIMD2<Int>,count: Int)
        
        // not sure what this neads yet
        @available(OSX 10.14, *)
        case typeTextureBuffer(size: Int)
        
        public var value: Int {
            switch self {
            case .type1D(_):
                return 0
            case .type1DArray(_,_):
                return 1
            case .type2D(_):
                return 2
            case .type2DArray(_,_):
                return 3
            case .type2DMultisample(_,_):
                return 4
            case .typeCube(_):
                return 5
            case .typeCubeArray(_,_):
                return 6
            case .type3D(_):
                return 7
            case .type2DMultisampleArray(_,_):
                return 8
            case .typeTextureBuffer(_):
                return 0
            }
        }
        
        public var metalType: MTLTextureType! {
            MTLTextureType(rawValue: UInt(value))
        }
        
    }
    
}
