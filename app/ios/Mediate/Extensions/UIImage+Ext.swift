//
//  UIImage+Ext.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 30.11.2022.
//

import UIKit
import VideoToolbox

extension UIImage {
    func crop(_ from:CGPoint) -> UIImage? {
        let screen = UIScreen.main.bounds
        let rect = CGRect(x: (size.width*from.x / screen.width)-75,
                          y: (size.height*from.y / screen.height)-75,
                          width: 150,
                          height: 150)
        
        let img = cgImage?.cropping(to: rect)
        guard let img = img else { return nil }
        return UIImage(cgImage: img)
    }
    
    func saveJpeg(name: String,folder:String) {
     guard let folderUrl = FileManager.default.createFolder(name: folder) else { return }
        
        let fileName = name + ".jpeg"
        let fileUrl = folderUrl.appendingPathComponent(fileName)
        guard let data = jpegData(compressionQuality: 1) else { return }

        do {
            try data.write(to: fileUrl)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    @discardableResult func savePNG(name:String) -> URL? {
        guard let folderURL = FileManager.default.createFolder(name: "RT-Images") else {
            return nil
        }
        let imageUrl = folderURL.appendingPathComponent(name+".png")
        try? pngData()?.write(to: imageUrl)
        return imageUrl
    }
    
    func pixelData() -> [UInt16]? {
        let size = self.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt16](repeating: 0, count: Int(dataSize))
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 16,
                                bytesPerRow: Int(size.width) * MemoryLayout<UInt16>.size * 4,
                                space: CGColorSpace(name: CGColorSpace.linearGray)!,
                                bitmapInfo: CGImageAlphaInfo.none.rawValue)
        guard let cgImage = self.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        return pixelData
    }
    
    convenience init(name:String,ext:String) {
        let fileURL = Bundle.main.url(forResource: name, withExtension: ext)!
        let data = try! Data(contentsOf: fileURL)
        self.init(data: data)!
    }
    
    convenience init?(pixelBuffer: CVPixelBuffer?) {
        guard let pixelBuffer = pixelBuffer else { return nil }
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        guard let cgImage = cgImage else {
            return nil
        }
        
        self.init(cgImage: cgImage)
    }
}
