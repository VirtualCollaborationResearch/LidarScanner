//
//  ScanARViewController.swift
//  HomeTwin-iOS
//
//  Created by Hatice Nur OKUR on 31.10.2022.
//

import ARKit
import RealityKit
import SwiftUI
import Combine

class ScanARViewController: UIViewController {
        
    var viewModel:ScanViewViewModel

    var arView: ScanARView { self.view as! ScanARView }
    
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: ScanViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ScanARView()
        arView.session.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNotificationListener()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    private func setupNotificationListener() {
        
        viewModel.reset.sink { [weak self] _ in
            self?.arView.reset()
        }.store(in: &cancellable)
        
        viewModel.$isScanning.sink { [weak self] value in
            value ? self?.arView.startScanning() : self?.arView.session.pause()
        }.store(in: &cancellable)
        
        viewModel.snapShot.sink { [weak self] areaId in
            self?.arView.snapshot(saveToHDR: true, completion: { image in
                image?.saveImage(imageName: areaId.uuidString, folder: "Map Images")
            })
        }.store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: .pauseSession, object: nil).sink {  [weak self] _ in
            self?.arView.session.pause()
        }.store(in: &cancellable)
    }
}

extension ScanARViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
       
        let ambientIntensity = frame.lightEstimate?.ambientIntensity ?? -13
        let lightSufficient = ambientIntensity > 100

        if viewModel.isLightingSufficient.value != lightSufficient {
            viewModel.isLightingSufficient.value = lightSufficient
        }
        
        if let rotation = UIApplication.shared.currentWindow?.windowScene?.interfaceOrientation,
           frame.camera.trackingState == .normal 
        {
            viewModel.rtabmap.postOdometryEvent(frame: frame, orientation: rotation, viewport: view.frame.size)
        }
    }
}

struct ScanARViewRepresentable: UIViewControllerRepresentable {
    @StateObject var viewModel: ScanViewViewModel

    typealias UIViewControllerType = ScanARViewController
    
    func makeUIViewController(context: Context) -> ScanARViewController {
        return ScanARViewController(viewModel: viewModel)
    }
    func updateUIViewController(_ uiViewController:
                                ScanARViewRepresentable.UIViewControllerType, context:
                                UIViewControllerRepresentableContext<ScanARViewRepresentable>) { }
}

