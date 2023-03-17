//
//  StreamViewController.swift
//  LidarScanner
//
//  Created by Oğuz Öztürk on 15.03.2023.
//

import ARKit
import RealityKit
import SwiftUI
import Combine

final class StreamViewController: UIViewController {
    
    private var viewModel:StreamViewModel
    
    private var arView: ARSceneView { self.view as! ARSceneView }
    private var arFrameReciever = PassthroughSubject<ARFrame,Never>()
    
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: StreamViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ARSceneView()
        arView.session.delegate = self
        arView.loadModel(scanId: viewModel.scan.id)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNotificationListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    private func setupNotificationListener() {
        
        viewModel.$isScanning
            .dropFirst()
            .sink { [unowned self] value in
            value ? arView.reset() : arView.stopScanning()
        }.store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: .pauseSession, object: nil).sink {  [weak self] _ in
            self?.arView.stopScanning()
        }.store(in: &cancellable)
        
//        arFrameReciever
//            .throttle(for: .seconds(1), scheduler: DispatchQueue.global(), latest: true)
//            .sink { [weak self] frame in
//
//            }.store(in: &cancellable)
    }
}

extension StreamViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if frame.camera.trackingState == .normal {
           // self.arFrameReciever.send(frame)
        }
        if viewModel.mapStatus.value != frame.worldMappingStatus {
            viewModel.mapStatus.value = frame.worldMappingStatus
            print("worldMappingStatus",frame.worldMappingStatus)
        }
        
        let ambientIntensity = frame.lightEstimate?.ambientIntensity ?? -13
        let lightSufficient = ambientIntensity > 100

        if viewModel.isLightingSufficient.value != lightSufficient {
            viewModel.isLightingSufficient.value = lightSufficient
            print("lightSufficient",lightSufficient)
        }
    }
}

struct StreamARViewRepresentable: UIViewControllerRepresentable {
    @StateObject var viewModel: StreamViewModel
    
    typealias UIViewControllerType = StreamViewController
    
    func makeUIViewController(context: Context) -> StreamViewController {
        return StreamViewController(viewModel: viewModel)
    }
    func updateUIViewController(_ uiViewController:
                                StreamARViewRepresentable.UIViewControllerType, context:
                                UIViewControllerRepresentableContext<StreamARViewRepresentable>) { }
}

