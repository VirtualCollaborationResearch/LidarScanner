//
//  ScanViewSheetAndAlertTypes.swift
//  HomeTwin-iOS
//
//  Created by Hatice Nur OKUR on 31.10.2022.
//

import Foundation


enum ScanViewSheetTypes {
    case areaName
}

enum ScanViewAlertTypes:String {
    case mapSaved = "Your map successfully saved"
    case roomNotSelected = "Please select a room"
    case labelCannotBeEmpty = "Label can not be emtpy."
    case errorWhileSavingMap = "Error occured while saving map"
    case error
}
