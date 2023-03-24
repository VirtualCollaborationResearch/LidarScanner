//
//  StreamViewModel.swift
//  LidarScanner
//
//  Created by Oğuz Öztürk on 15.03.2023.
//
import Combine
import SwiftUI
import ARKit
import WebRTC
import FirebaseFirestore

final class StreamViewModel:NSObject, ObservableObject {
    var mapStatus = CurrentValueSubject<ARFrame.WorldMappingStatus,Never>(.notAvailable)
    var isLightingSufficient = CurrentValueSubject<Bool,Never>(false)

    var signalingClient = SignalingClient()
    
    private var cancellable = Set<AnyCancellable>()
    let scan: Scan
    @Published var isScanning = true
    
    init(scan: Scan) {
        self.scan = scan
        super.init()
    }
   
    func doneTapped() {
        self.isScanning = false
    }
}
