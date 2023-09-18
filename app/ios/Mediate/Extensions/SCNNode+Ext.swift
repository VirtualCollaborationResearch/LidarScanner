//
//  SCNNode+Ext.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 3.01.2023.
//

import ARKit

extension SCNNode {
    static func sphere() -> SCNNode {
        let plane = SCNSphere(radius: 0.02)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(named: "AccentColor")
        plane.materials = [material]
        let node = SCNNode(geometry: plane)
        return node
    }
}
