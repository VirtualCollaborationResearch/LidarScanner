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
import Zip

final class ScanViewViewModel:ObservableObject {
    
    private var cancellable = Set<AnyCancellable>()
    
    var reset = PassthroughSubject<Bool,Never>()
    var snapShot = PassthroughSubject<UUID,Never>()
    var isLightingSufficient = CurrentValueSubject<Bool,Never>(false)
    @Published var isScanning = true
    var openedDatabasePath:URL?
    
    var rtabmap = RTABMap()

    init() {
        setupNotificationListener()
    }
    
    private func setupNotificationListener() {
        NotificationCenter.default.publisher(for: .toggleSheet).sink {  [weak self] _ in
            
        }.store(in: &cancellable)
    }
    
    func resetTapped() {
        reset.send(true)
    }
    
    func doneTapped() {
        // snapShot.send(UUID())
        isScanning = false

    }
    
 
}



