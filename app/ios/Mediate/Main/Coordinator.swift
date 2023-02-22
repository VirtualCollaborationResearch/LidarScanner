//
//  Coordinator.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 5.10.2022.
//

import Combine
import SwiftUI

@MainActor
class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    @Published var isScanning = false
    
    func returnToHomePage() {
        path.removeLast(path.count)
    }
    
    func scanListView() {
        path.append(Destination.scanListView)
    }
    
    func modelViewer(scan:Scan) {
        path.append(Destination.modelViewer(scan))
    }
    
    func menuView() {
        path.append(Destination.menuView)
    }
    
    func goToScanView() {
        isScanning = true
    }
    
    func goToHomeAreas() {
        isScanning = false
    }
    
    func tapOnSecondPage() {
        path.removeLast()
    }
}
