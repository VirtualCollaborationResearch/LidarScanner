//
//  NotificationNames.swift
//  Scanner
//
//  Created by Oğuz Öztürk on 9.08.2022.
//

import Foundation

extension Notification.Name {
    
    static let pauseSession = Notification.Name("pauseSession")
    static let toggleSheet = Notification.Name("toggleSheet")
    static let snapshotImage = Notification.Name("snapshotImage")
    static let exportResult = Notification.Name("exportResult")

}

extension NotificationCenter {
    func send(_ name:Notification.Name,_ data:Any? = nil) {
        NotificationCenter.default.post(name: name, object: nil,userInfo: ["data":NotifWrapper(theValue: data)])
    }
}

class NotifWrapper<T> {
    var wrappedValue: T
    init(theValue: T) {
        wrappedValue = theValue
    }
}
