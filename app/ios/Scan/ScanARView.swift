//
//  ScanARView.swift
//  RTABMapApp
//
//  Created by Oğuz Öztürk on 21.02.2023.
//

import ARKit
import RealityKit

final class ScanARView:ARView {
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        automaticallyConfigureSession = false
        debugOptions = [.showSceneUnderstanding]
        renderOptions = [.disablePersonOcclusion, .disableDepthOfField, .disableMotionBlur]
        addOverlay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    func startScanning() {
        session.run(.defaultConfiguration)
    }
    
    func addOverlay() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = session
        coachingOverlay.delegate = self
        coachingOverlay.frame.origin = center
        addSubview(coachingOverlay)
    }
    
    func reset() {
        if let configuration = session.configuration {
            session.run(configuration, options: [.resetSceneReconstruction,.resetTracking,.removeExistingAnchors])
        }
    }
}

extension ScanARView: ARCoachingOverlayViewDelegate {
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) { }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) { }
    
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        reset()
    }
}
