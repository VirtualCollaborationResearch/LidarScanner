//
//  CVPixelBuffer+Ext.swift
//  LidarScanner
//
//  Created by Oğuz Öztürk on 9.03.2023.
//

import UIKit
import Accelerate
import ARKit

extension CVPixelBuffer {
    var confidenceImage:UIImage? {
        
        func confienceValueToPixcelValue(confidenceValue: UInt8) -> UInt8 {
            guard confidenceValue <= ARConfidenceLevel.high.rawValue else {return 0}
            return UInt8(floor(Float(confidenceValue) / Float(ARConfidenceLevel.high.rawValue) * 255))
        }
        
        let flags = CVPixelBufferLockFlags(rawValue: 0)
        
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(self, flags),
              let base = CVPixelBufferGetBaseAddress(self) else {
            return nil
        }
        
        let width = CVPixelBufferGetWidth(self)
        let height = CVPixelBufferGetHeight(self)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(self)
        
        for i in stride(from: 0, to: bytesPerRow*height, by: MemoryLayout<UInt8>.stride) {
            let data = base.load(fromByteOffset: i, as: UInt8.self)
            let pixelValue = confienceValueToPixcelValue(confidenceValue: data)
            base.storeBytes(of: pixelValue, toByteOffset: i, as: UInt8.self)
        }
        
        let buffer = vImage_Buffer(data: base,
                                   height: vImagePixelCount(height),
                                   width: vImagePixelCount(width),
                                   rowBytes: bytesPerRow)
        
        let grayscaleImageFormat = vImage_CGImageFormat(
            bitsPerComponent: 8,
            bitsPerPixel: 8,
            colorSpace: CGColorSpace(name: CGColorSpace.linearGray)!,
            bitmapInfo: .byteOrderDefault,
            renderingIntent: .defaultIntent
        )!
        
        let cgImage = try? buffer.createCGImage(format: grayscaleImageFormat)
        
        CVPixelBufferUnlockBaseAddress(self, flags)
        return UIImage(cgImage: cgImage!)
    }
    
    
    var depth16BitImage:UIImage? {
        let flags = CVPixelBufferLockFlags(rawValue: 0)
        
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(self, flags),
              let base = CVPixelBufferGetBaseAddress(self) else {
            return nil
        }
        
        let height = CVPixelBufferGetHeight(self)
        let width = CVPixelBufferGetWidth(self)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(self)
        let depthData = Data(bytes: base, count: (bytesPerRow*height))
        let inBitsPerPixel = 32
        let outBitsPerPixel = 16
        var bufferU16 = vImage_Buffer()
        
        let dataPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: height * width * inBitsPerPixel / 8)
        vImageBuffer_Init(&bufferU16, UInt(height), UInt(width), UInt32(outBitsPerPixel), vImage_Flags(kvImageNoFlags))
        depthData.copyBytes(to: dataPtr, count: height * width * inBitsPerPixel / 8)
        var bufferF32 = vImage_Buffer(data: dataPtr,
                                      height: vImagePixelCount(height),
                                      width: vImagePixelCount(width),
                                      rowBytes: width * inBitsPerPixel / 8)
        vImageConvert_FTo16U(&bufferF32, &bufferU16, 0, 0.001, vImage_Flags(kvImageNoFlags))
        let grayscaleImageFormat = vImage_CGImageFormat(
            bitsPerComponent: 16,
            bitsPerPixel: 16,
            colorSpace: CGColorSpace(name: CGColorSpace.linearGray)!,
            bitmapInfo: .byteOrder16Little,
            renderingIntent: .defaultIntent
        )!
        let cgImage = try! bufferU16.createCGImage(format: grayscaleImageFormat)
        
        free(dataPtr)
        free(bufferU16.data)
        CVPixelBufferUnlockBaseAddress(self,  flags)
        return UIImage(cgImage: cgImage)
    }
}
