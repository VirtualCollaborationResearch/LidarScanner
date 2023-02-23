//
//  String+Ext.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 30.11.2022.
//

import Foundation

extension String {
    
    func imageFromDisk(_ folder:String) -> URL? {

        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(folder).appendingPathComponent(self+".jpeg")
            return imageUrl

        }

        return nil
    }
    
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
}

extension Date {
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY-HH.mm"
        return dateFormatter.string(from: self)
    }
}


extension String {
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY-HH.mm"
        dateFormatter.timeZone = .current
        return dateFormatter.date(from: self)
    }
}
