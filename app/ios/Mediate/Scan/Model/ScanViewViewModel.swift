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
    var scanId = UUID()
    var rtabmap = RTABMap()
    var closeScanning = PassthroughSubject<Bool,Never>()
    @Published var isScanning = true
    var snapShot = PassthroughSubject<UUID,Never>()

    init() {
        rtabmap.setupCallbacksWithCPP()
        setupNotificationListener()
    }
    
    private func setupNotificationListener() {        
        NotificationCenter.default.publisher(for: .exportResult).sink {  [weak self] notif in
            if let notif = notif.userInfo?["data"] as? NotifWrapper<Any?>,
               let scan = notif.wrappedValue as? Scan,
               let _ = scan.objUrl {
                UserDefaults.scans.append(scan)
                self?.closeScanning.send(true)
            }
        }.store(in: &cancellable)
    }
    
    func doneTapped() {
        snapShot.send(scanId)
        isScanning = false
    }
}



