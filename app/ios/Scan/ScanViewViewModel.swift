//
//  ScanViewViewModel.swift
//  HomeTwin-iOS
//
//  Created by Hatice Nur OKUR on 31.10.2022.
//

import Foundation
import Combine
import SwiftUI
import ARKit

final class ScanViewViewModel:ObservableObject {
    
    private var cancellable = Set<AnyCancellable>()
    var rtabmap = RTABMap()
    var url:URL?
    @Published var showSheet = false
    @Published var isScanning = true
    var snapShot = PassthroughSubject<UUID,Never>()

    init() {
        rtabmap.setupCallbacksWithCPP()
        setupNotificationListener()
    }
    
    private func setupNotificationListener() {
        NotificationCenter.default.publisher(for: .toggleSheet).sink {  [weak self] _ in
            
        }.store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: .exportResult).sink {  [weak self] notif in
            if let notif = notif.userInfo?["data"] as? NotifWrapper<Any?>,
               let scan = notif.wrappedValue as? Scan,
               let url = scan.objUrl {
                self?.url = url
                self?.showSheet.toggle()
            }
        }.store(in: &cancellable)
    }
    
    func doneTapped() {
        snapShot.send(UUID())
        isScanning = false
    }
}



