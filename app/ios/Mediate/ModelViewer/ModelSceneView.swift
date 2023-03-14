//
//  ModelSceneView.swift
//  LidarScanner
//
//  Created by Oğuz Öztürk on 10.03.2023.
//

import SceneKit
import UIKit
import Combine
import SwiftUI
import SceneKit.ModelIO
final class ModelSceneView: SCNView {
    //    var node:SCNNode?
    var modelNode:SCNNode?
    
    init(url: URL?) {
        super.init(frame: .zero,options: nil)
        if let url = url {
            let mdlAsset = MDLAsset(url: url)
            mdlAsset.loadTextures()
            self.modelNode = SCNNode(mdlObject: mdlAsset.object(at: 0))
            self.scene = SCNScene()
            if let scene = scene, let model = modelNode {
                scene.rootNode.addChildNode(model)
                modelNode?.geometry?.firstMaterial?.lightingModel = .physicallyBased
                let spotLight = SCNNode()
                spotLight.light = SCNLight()
                spotLight.light?.type = .ambient
                scene.rootNode.addChildNode(spotLight)
                allowsCameraControl = true
                
                modelNode?.pivot = SCNMatrix4()

                let minimum = SIMD3<Float>(model.boundingBox.min)
                let maximum = SIMD3<Float>(model.boundingBox.max)
                
                let translation = (maximum + minimum) * 0.5

                modelNode?.pivot = SCNMatrix4MakeTranslation(translation.x, translation.y, translation.z)
                fixObjectOrientation()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
            override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
               
//                guard let location = touches.first?.location(in: self) else { return }
//                if let firstHit = hitTest(location, options: nil).first {
//                   if node == nil {
//                        node = SCNNode.snapDot(id: UUID())
//                        print("tappedNode found",firstHit.worldCoordinates,firstHit.worldNormal)
//                        node?.position = firstHit.worldCoordinates
//                        node?.look(at: firstHit.worldNormal)
//                        scene?.rootNode.addChildNode(node!)
//                        return
//                   }
//                }
            }
        //
        //    @objc func dragObject(touch: UIPanGestureRecognizer){
        //        if let firstHit = hitTest(touch.location(in: self), options: nil).first {
        //            node?.position = firstHit.worldCoordinates
        //            node?.look(at: firstHit.worldNormal)
        //        }
        //    }
    
    func fixObjectOrientation() {
        print("fixObjectOrientation")
        let xAngle = SCNMatrix4MakeRotation(degToRad(80), 1, 0, 0)
        let zAngle = SCNMatrix4MakeRotation(degToRad(-90), 0, 0, 1)
        let rotationMatrix = SCNMatrix4Mult(xAngle, zAngle)
        modelNode!.pivot = SCNMatrix4Mult(rotationMatrix, modelNode!.transform)
    }
    
    func degToRad(_ deg: Float) -> Float {
        return deg / 180 * .pi
    }
}

struct ModelScene:UIViewRepresentable {
    let url:URL?
    
    func makeUIView(context: Context) -> ModelSceneView {
        ModelSceneView(url: url)
    }
    
    func updateUIView(_ uiView: ModelSceneView, context: Context) { }
}
