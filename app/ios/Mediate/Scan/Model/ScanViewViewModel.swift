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
    var scanResult = PassthroughSubject<Scan,Never>()
    @Published var isScanning = true
    var modelCreationPercentage = PassthroughSubject<Float,Never>()

    init() {
        rtabmap.setupCallbacksWithCPP()
        rtabmap.addObserver(self)
        setupNotificationListener()
    }
    
    private func setupNotificationListener() {        
        NotificationCenter.default.publisher(for: .exportResult).sink {  [weak self] notif in
            if let notif = notif.userInfo?["data"] as? NotifWrapper<Any?>,
               let scan = notif.wrappedValue as? Scan {
                self?.scanResult.send(scan)
            }
        }.store(in: &cancellable)
    }
    
    func doneTapped() {
        self.isScanning = false
    }
    
    func saveRawData(frame:ARFrame) {
        let name = "\(frame.timestamp)"
        let folder = "\(scanId)/RawData/\(name)"
        autoreleasepool {
            CameraModel(camera: frame.camera, timeStamp: frame.timestamp).writeToDisk(name: name,folder: folder)
            UIImage(pixelBuffer: frame.capturedImage)?.saveJpeg(name: "texture", folder:folder)
            frame.sceneDepth?.depthMap.depth16BitImage?.savePNG(name: "depth",folder:folder)
            frame.sceneDepth?.confidenceMap?.confidenceImage?.savePNG(name: "confidence",folder:folder)
        }
    }
}

extension ScanViewViewModel: RTABMapObserver {
    func progressUpdated(_ rtabmap: RTABMap, count: Int, max: Int) {
        let percentage = min(100,100 * Float(count)/Float(max))
        DispatchQueue.main.async { [weak self] in
            self?.modelCreationPercentage.send(percentage)
        }
    }
}


