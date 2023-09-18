//
//  ARFrame+Ext.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 20.12.2022.
//

import ARKit
import MetalKit

extension ARFrame.WorldMappingStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notAvailable:
            return "Not Available"
        case .limited:
            return "Limited"
        case .extending:
            return "Extending"
        case .mapped:
            return "Mapped"
        @unknown default:
            return "Unknown"
        }
    }
    
    public var text: String {
        switch self {
        case .notAvailable:
            return "World map isn't available\nContinue scaninng"
        case .limited:
            return "Mapping is limited\nContinue scaninng"
        case .extending:
            return "Map is extending\nContinue scaninng"
        case .mapped:
            return "Map can be saved"
        @unknown default:
            return "Unknown"
        }
    }
}
