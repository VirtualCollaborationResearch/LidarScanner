//
//  UIImage+Ext.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 30.11.2022.
//

import UIKit

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
    
    func saveImage(imageName: String,folder:String) {
     guard let folderUrl = FileManager.default.createFolder(name: folder) else { return }
        
        let fileName = imageName + ".jpeg"
        let fileUrl = folderUrl.appendingPathComponent(fileName)
        guard let data = jpegData(compressionQuality: 1) else { return }

        do {
            try data.write(to: fileUrl)
        } catch let error {
            print("error saving file with error", error)
        }
    }
}
