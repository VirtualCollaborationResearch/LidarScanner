//
//  ARWorldTrackingConfiguration+Ext.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 16.12.2022.
//

import ARKit

extension ARConfiguration {
    static var defaultConfiguration: ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        configuration.isLightEstimationEnabled = true
        configuration.sceneReconstruction = .mesh
        configuration.frameSemantics = UserDefaults.isSmoothed ? .smoothedSceneDepth : .sceneDepth
        return configuration
    }
}
