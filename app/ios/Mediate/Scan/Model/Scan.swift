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
    
    func fileUrl(for typeOf:ScanDataTypes) -> URL? {
        FileManager.default.retrieveFile(folder: id.uuidString, name: dateStr, format:".\(typeOf.rawValue)")
    }
}

enum ScanDataTypes:String {
    case obj,mtl,jpg,usdz,zip
}
