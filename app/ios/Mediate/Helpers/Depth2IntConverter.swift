//
//  Depth2IntConverter.swift
//  LidarScanner
//
//  Created by Oğuz Öztürk on 8.03.2023.
//

import UIKit
import Accelerate
import ARKit

class Depth2IntConverter {
    // Convert each pixel from Float32 to UInt16
    var bufferU16 = vImage_Buffer()
    var bufferF32 = vImage_Buffer()
    var dataPtr: UnsafeMutablePointer<UInt8>
    var height_ = Int()
    var width_ = Int()
    let inBitsPerPixel = 32
    let outBitsPerPixel = 16
    
    init(height: Int, width: Int) {
        height_ = height
        width_ = width
        dataPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: height * width * inBitsPerPixel / 8)
        vImageBuffer_Init(&bufferU16, UInt(height), UInt(width), UInt32(outBitsPerPixel), vImage_Flags(kvImageNoFlags))
    }
    
    func convert(inputData: Data) -> UIImage {
        inputData.copyBytes(to: dataPtr, count: height_ * width_ * inBitsPerPixel / 8)
        bufferF32 = vImage_Buffer(data: dataPtr,
                                  height: vImagePixelCount(height_),
                                  width: vImagePixelCount(width_),
                                  rowBytes: width_ * inBitsPerPixel / 8)
        
        vImageConvert_FTo16U(&bufferF32, &bufferU16, 0, 0.001, vImage_Flags(kvImageNoFlags))
        
        let grayscaleImageFormat = vImage_CGImageFormat(
            bitsPerComponent: 16,
            bitsPerPixel: 16,
            colorSpace: CGColorSpace(name: CGColorSpace.linearGray)!,
            bitmapInfo: .byteOrder16Little,
            renderingIntent: .defaultIntent
        )!
        
        let cgImage = try! bufferU16.createCGImage(format: grayscaleImageFormat)
        let outImage = UIImage(cgImage: cgImage)
        return outImage
    }
    
    deinit {
        free(dataPtr)
        free(bufferU16.data)
    }
}

class Confidence2IntConverter {
    // Convert each pixel from Float32 to UInt16
    var bufferF8 = vImage_Buffer()
    var dataPtr: UnsafeMutablePointer<UInt8>
    var height_ = Int()
    var width_ = Int()
    let inBitsPerPixel = 8
    
    init(height: Int, width: Int) {
        height_ = height
        width_ = width
        dataPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: height * width * inBitsPerPixel / 8)
    }
    
    func convert(inputData: Data) -> UIImage {
        inputData.copyBytes(to: dataPtr, count: height_ * width_ * inBitsPerPixel / 8)
        bufferF8 = vImage_Buffer(data: dataPtr,
                                 height: vImagePixelCount(height_),
                                 width: vImagePixelCount(width_),
                                 rowBytes: width_ * inBitsPerPixel / 8)
        
        
        let grayscaleImageFormat = vImage_CGImageFormat(
            bitsPerComponent: 8,
            bitsPerPixel: 8,
            colorSpace: CGColorSpace(name: CGColorSpace.extendedLinearGray)!,
            bitmapInfo: .byteOrderDefault,
            renderingIntent: .defaultIntent
        )!
        
        let cgImage = try! bufferF8.createCGImage(format: grayscaleImageFormat)
        let outImage = UIImage(cgImage: cgImage)
        return outImage
    }
    
    deinit {
        free(dataPtr)
        free(bufferF8.data)
    }
}
