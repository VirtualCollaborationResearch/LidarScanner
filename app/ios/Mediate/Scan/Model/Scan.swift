//
//  Scan.swift
//  RTABMapApp
//
//  Created by Oğuz Öztürk on 22.02.2023.
//

import Foundation

struct Scan:Codable,Identifiable,Equatable,Hashable {
    var id:UUID
    var dateStr = Date().convertToString()
    var name:String?
    
    var objUrl:URL? {
        FileManager.default.retrieveFile(folder: id.uuidString, name: dateStr, format:".obj")
    }
    
    var mtlUrl:URL? {
        FileManager.default.retrieveFile(folder: id.uuidString, name: dateStr, format:".mtl")
    }
    
    var textureUrl:URL? {
        FileManager.default.retrieveFile(folder: id.uuidString, name: dateStr, format:".jpg")
    }
    
    var usdzUrl:URL? {
        FileManager.default.retrieveFile(folder: id.uuidString, name: dateStr, format:".usdz")
    }
}
