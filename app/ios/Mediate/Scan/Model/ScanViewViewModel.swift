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
    var doneScanning = PassthroughSubject<Bool,Never>()
    @Published var isScanning = true
    var snapShot = PassthroughSubject<UUID,Never>()
    var modelCreationPercentage = PassthroughSubject<Float,Never>()

    init() {
        rtabmap.setupCallbacksWithCPP()
        rtabmap.addObserver(self)
        setupNotificationListener()
    }
    
    private func setupNotificationListener() {        
        NotificationCenter.default.publisher(for: .exportResult).sink {  [weak self] notif in
            if let notif = notif.userInfo?["data"] as? NotifWrapper<Any?>,
               let _ = notif.wrappedValue as? Scan {
                self?.doneScanning.send(true)
            }
        }.store(in: &cancellable)
    }
    
    func doneTapped() {
        self.isScanning = false
    }
}

extension ScanViewViewModel: RTABMapObserver {
    func progressUpdated(_ rtabmap: RTABMap, count: Int, max: Int) {
        let percentage = min(100,100 * Float(count)/Float(max))
        print("**** ",count,max)
        DispatchQueue.main.async { [weak self] in
            self?.modelCreationPercentage.send(percentage)
        }
    }
}


