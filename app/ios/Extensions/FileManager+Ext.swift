//
//  FileManager+Ext.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 9.02.2023.
//

import Foundation

extension FileManager {
    func createFolder(name: String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }
        
        let folderUrl = documentsDirectory.appendingPathComponent(name)
        
        if !FileManager.default.fileExists(atPath: folderUrl.path) {
            do {
                try FileManager.default.createDirectory(at: folderUrl, withIntermediateDirectories: false)
                return folderUrl
                
            } catch let removeError {
                print("couldn't remove file at path", removeError)
                return nil
            }
        } else {
            return folderUrl
            
        }
    }
    
    func retrieveObj(folder:String,name:String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }
        let folderUrl = documentsDirectory.appendingPathComponent(folder)
        let objurl = folderUrl.appendingPathComponent(name+".obj")
        return objurl
    }
}
