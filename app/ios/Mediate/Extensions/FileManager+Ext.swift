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
                try FileManager.default.createDirectory(at: folderUrl, withIntermediateDirectories: true)
                return folderUrl
                
            } catch let removeError {
                print("couldn't remove file at path", removeError)
                return nil
            }
        } else {
            return folderUrl
            
        }
    }
    
    func retrieveFile(folder:String,name:String,format:String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }
        let folderUrl = documentsDirectory.appendingPathComponent(folder)
        let objurl = folderUrl.appendingPathComponent(name+format)
        return FileManager.default.fileExists(atPath: objurl.path) ? objurl : nil
    }
}
