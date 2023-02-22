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
    var url:URL

    var body: some View {
        SceneView(scene: try? SCNScene(url:url), options: [.allowsCameraControl,.autoenablesDefaultLighting])
            .navigationTitle("Model")
            .navigationBarTitleDisplayMode(.inline)
    }
}
