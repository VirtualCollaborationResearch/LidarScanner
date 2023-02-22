//
//  SCNNode+Ext.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 3.01.2023.
//

import ARKit

extension SCNNode {
    static func appLabel(id:UUID) -> SCNNode {
        let plane = SCNPlane(width: 0.18, height: 0.18)
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = UIImage(named: "label")
        plane.materials = [material]
        let node = SCNNode(geometry: plane)
        node.name = id.uuidString
        let billboardConstraint = SCNBillboardConstraint()
        node.constraints = [billboardConstraint]
        return node
    }
}
