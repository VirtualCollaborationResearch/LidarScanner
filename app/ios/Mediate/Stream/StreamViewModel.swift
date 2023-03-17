//
//  StreamViewModel.swift
//  LidarScanner
//
//  Created by Oğuz Öztürk on 15.03.2023.
//
import Combine
import SwiftUI
import ARKit

final class StreamViewModel:ObservableObject {
    var mapStatus = CurrentValueSubject<ARFrame.WorldMappingStatus,Never>(.notAvailable)
    var isLightingSufficient = CurrentValueSubject<Bool,Never>(false)

    private var cancellable = Set<AnyCancellable>()
    let scan: Scan
    @Published var isScanning = true

    init(scan: Scan) {
        self.scan = scan
        setupNotificationListener()
    }
    
    private func setupNotificationListener() {
        NotificationCenter.default.publisher(for: .exportResult).sink {  [weak self] notif in
           
        }.store(in: &cancellable)
    }
    
    func doneTapped() {
        self.isScanning = false
    }
}
