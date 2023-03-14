//
//  SCNNode+Ext.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 3.01.2023.
//

import ARKit

extension SCNNode {
    static func snapDot(id:UUID) -> SCNNode {
        let plane = SCNPlane(width: 0.2, height: 0.2)
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = UIColor.blue
        plane.materials = [material]
        let node = SCNNode(geometry: plane)
        node.name = id.uuidString
        return node
    }
}
