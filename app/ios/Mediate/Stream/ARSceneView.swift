//
//  ARSceneView.swift
//  LidarScanner
//
//  Created by Oğuz Öztürk on 15.03.2023.
//

import ARKit
import Combine

final class ARSceneView:ARSCNView {
    
    init() {
        super.init(frame: .zero,options: nil)
        UIApplication.shared.isIdleTimerDisabled = true
        addOverlay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addOverlay() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = session
        coachingOverlay.delegate = self
        coachingOverlay.frame.origin = center
        coachingOverlay.accessibilityElementsHidden = true
        addSubview(coachingOverlay)
    }
    
   @discardableResult func loadModel(scanId:UUID) -> ARWorldMap? {
        if let data = UserDefaults.standard.data(forKey: "Map_" + scanId.uuidString),
           let unarchiver = try? NSKeyedUnarchiver.unarchivedObject(
            ofClasses: [ARWorldMap.classForKeyedUnarchiver()],
            from: data),
           let worldMap = unarchiver as? ARWorldMap {
            let configuration = ARConfiguration.defaultConfiguration
            configuration.initialWorldMap = worldMap
            session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            return worldMap
        }
        return nil
    }
    
    func stopScanning() {
        session.pause()
        session.delegate = nil
        removeFromSuperview()
        window?.resignKey()
    }
    
    func reset() {
        if let configuration = session.configuration {
            session.run(configuration, options: [.resetSceneReconstruction,.resetTracking,.removeExistingAnchors])
        }
    }
}

extension ARSceneView: ARCoachingOverlayViewDelegate {
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {  }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) { }
    
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) { }
}

