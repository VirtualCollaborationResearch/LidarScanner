//
//  ARCamera+Ext.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 30.12.2022.
//

import Foundation
import ARKit

extension ARCamera.TrackingState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .normal:
            return "Normal"
        case .notAvailable:
            return "Not Available"
        case .limited(.initializing):
            return "Initializing"
        case .limited(.excessiveMotion):
            return "Excessive Motion"
        case .limited(.insufficientFeatures):
            return "Insufficient Features"
        case .limited(.relocalizing):
            return "Relocalizing"
        case .limited:
            return "Unspecified Reason"
        }
    }
}

extension ARCamera.TrackingState {

    var isRelocalizing: Bool {
        if case .limited(reason: .relocalizing) = self {
            return true
        } else {
            return false
        }
    }
    
    var isDegradedOrMissing: Bool {
        return !isNormal || !isRelocalizing
    }
    
    var isNormal: Bool {
        if case .normal = self {
            return true
        } else {
            return false
        }
    }
}
