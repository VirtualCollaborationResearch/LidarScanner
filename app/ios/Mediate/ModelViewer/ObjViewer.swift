//
//  ObjViewer.swift
//  RTABMapApp
//
//  Created by Oğuz Öztürk on 22.02.2023.
//

import UIKit
import SwiftUI
import SceneKit

class ObjViewModel: NSObject, ObservableObject {
    var scan:Scan
    var scene:SCNScene?
    
    init(scan:Scan) {
        self.scan = scan
        super.init()
        
        if let url = scan.objUrl {
            let mdlAsset = MDLAsset(url: url)
            mdlAsset.loadTextures()
            self.scene = SCNScene(mdlAsset: mdlAsset)
            self.scene?.rootNode.geometry?.firstMaterial?.lightingModel = .physicallyBased
            let spotLight = SCNNode()
            spotLight.light = SCNLight()
            spotLight.light?.type = .area
            scene?.rootNode.addChildNode(spotLight)
        }
    }
}

struct ObjViewer:View {
    @StateObject var viewModel:ObjViewModel
    
    var body: some View {
        SceneView(scene: viewModel.scene, options: [.allowsCameraControl,.autoenablesDefaultLighting])
            .navigationTitle(viewModel.scan.dateStr)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement:.navigationBarTrailing) {
                    Menu {
                        
                        if let obj = viewModel.scan.objUrl,
                           let mtl = viewModel.scan.mtlUrl,
                           let texture = viewModel.scan.textureUrl {
                            ShareLink( "Obj File", items: [obj,mtl,texture])
                        }
                        
                        if let usdz = viewModel.scan.usdzUrl {
                            ShareLink( "USDZ File", item: usdz)
                        }
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
    }
}
