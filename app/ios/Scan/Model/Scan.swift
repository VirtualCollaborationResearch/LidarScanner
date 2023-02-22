//
//  Scan.swift
//  RTABMapApp
//
//  Created by Oğuz Öztürk on 22.02.2023.
//

import Foundation

struct Scan:Codable,Identifiable,Equatable,Hashable {
    var id:UUID
    var dateStr:String
    
    var objUrl:URL? {
        FileManager.default.retrieveObj(folder: id.uuidString, name: dateStr)
    }
}
