//
//  ObjViewer.swift
//  RTABMapApp
//
//  Created by Oğuz Öztürk on 22.02.2023.
//

import UIKit
import SwiftUI
import SceneKit

struct ObjViewer:View {
    var scan:Scan
    
    var scene:SCNScene? {
        guard let url = scan.objUrl
        else { return nil }
        let scene = try? SCNScene(url:url )
        return scene
    }

    var body: some View {
        SceneView(scene: scene, options: [.allowsCameraControl,.autoenablesDefaultLighting])
            .navigationTitle(scan.dateStr)
            .navigationBarTitleDisplayMode(.inline)
    }
}
