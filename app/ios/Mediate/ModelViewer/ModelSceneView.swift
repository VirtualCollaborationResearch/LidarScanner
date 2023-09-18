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
    var viewModel:ModelSceneViewModel
    var modelNode:SCNNode?
    
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: ModelSceneViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero,options: nil)
        if let url = viewModel.scan.fileUrl(for: .obj) {
            let mdlAsset = MDLAsset(url: url)
            mdlAsset.loadTextures()
            self.modelNode = SCNNode(mdlObject: mdlAsset.object(at: 0))
            self.scene = SCNScene()
            if let scene = scene, let model = modelNode {
                scene.rootNode.addChildNode(model)
                model.renderingOrder = 3
                modelNode?.geometry?.firstMaterial?.lightingModel = .physicallyBased
                let spotLight = SCNNode()
                spotLight.light = SCNLight()
                spotLight.light?.type = .ambient
                scene.rootNode.addChildNode(spotLight)
                allowsCameraControl = true
                defaultCameraController.inertiaFriction = 0.2
                modelNode?.pivot = SCNMatrix4()
                
                let minimum = SIMD3<Float>(model.boundingBox.min)
                let maximum = SIMD3<Float>(model.boundingBox.max)
                
                let translation = (maximum + minimum) * 0.5
                
                modelNode?.pivot = SCNMatrix4MakeTranslation(translation.x, translation.y, translation.z)
                fixObjectOrientation()
            }
        }
        
        viewModel.cleanMeasure.sink { [weak self] value in
            self?.cleanMeasure(id:value)
        }.store(in: &cancellable)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in 0..<viewModel.measures.count {
            if let line = viewModel.measures[i].line {
                let point = projectPoint(line.position)
                viewModel.measures[i].lineLocation = point.screenLocation
            }
        }
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if let firstHit = hitTest(sender.location(in: self), options: nil).first {
            if let last = viewModel.measures.last {
                if viewModel.measures.last?.p2 == nil {
                    let p2 = addSphereTo(firstHit.worldCoordinates, id:last.id)
                    viewModel.measures[viewModel.measures.count-1].p2 = p2
                    drawLinebetweenNodes()
                } else {
                    let p1 = addSphereTo(firstHit.worldCoordinates)
                    viewModel.measures.append(MeasureNode(p1: p1))
                }
            } else {
                let p1 = addSphereTo(firstHit.worldCoordinates)
                viewModel.measures.append(MeasureNode(p1: p1))
            }
        }
    }
    
    func addSphereTo(_ position:SCNVector3,id:String = UUID().uuidString) -> SCNNode {
        let sphere = SCNNode.sphere()
        sphere.name = id
        sphere.position = position
        scene?.rootNode.addChildNode(sphere)
        return sphere
    }
    
    func cleanMeasure(id:String) {
        scene?.rootNode.childNodes.forEach {
            if $0.name == id {
                $0.removeFromParentNode()
            }
        }
    }
    
    func drawLinebetweenNodes() {
        if let measure = viewModel.measures.last, let p2 = measure.p2 {
            let p1 = measure.p1
            let lineWithDistance = SCNGeometry.cylinderLine(from: p1.position, to: p2.position, segments: 3)
            let line = lineWithDistance.0
            let distance = lineWithDistance.1
            line.name = measure.id
            scene?.rootNode.addChildNode(line)
            let point = projectPoint(line.position)
            viewModel.measures[viewModel.measures.count-1].line = line
            viewModel.measures[viewModel.measures.count-1].lineLocation = point.screenLocation
            viewModel.measures[viewModel.measures.count-1].distance = "\(Int(distance*100))cm"
        }
    }
    
    func fixObjectOrientation() {
        let xAngle = SCNMatrix4MakeRotation(80.degree, 1, 0, 0)
        let zAngle = SCNMatrix4MakeRotation((-90).degree, 0, 0, 1)
        let rotationMatrix = SCNMatrix4Mult(xAngle, zAngle)
        modelNode!.pivot = SCNMatrix4Mult(rotationMatrix, modelNode!.transform)
    }
}

struct ModelSceneRepresentable:UIViewRepresentable {
    var viewModel:ModelSceneViewModel
    
    func makeUIView(context: Context) -> ModelSceneView {
        ModelSceneView(viewModel: viewModel)
    }
    
    func updateUIView(_ uiView: ModelSceneView, context: Context) { }
}

struct MeasureNode:Identifiable, Equatable {
    var id: String {
        p1.name ?? UUID().uuidString
    }
    let p1:SCNNode
    var p2:SCNNode?
    var line:SCNNode?
    var lineLocation:CGPoint?
    var distance:String?
}
