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
    private var arFrameReciever = PassthroughSubject<ARFrame,Never>()

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
        
        viewModel.$isScanning.sink { [unowned self] value in
            if value {
                viewModel.rtabmap.start(id: viewModel.scanId)
                arView.startScanning()
            } else {
                arView.snapshot(saveToHDR: true, completion: { [unowned self] image in
                    image?.saveJpeg(name: viewModel.scanId.uuidString, folder: "Map Images")
                    arView.stopScanning()
                    viewModel.rtabmap.stop()
                })
            }
        }.store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: .pauseSession, object: nil).sink {  [weak self] _ in
            self?.arView.stopScanning()
        }.store(in: &cancellable)
        
        arFrameReciever
            .throttle(for: .seconds(0.5), scheduler: DispatchQueue.global(), latest: true)
            .sink { frame in
                let imageName = UUID().uuidString
                CameraModel(frame: frame).writeToDisk(name: imageName)
                UIImage(pixelBuffer: frame.capturedImage)?.saveJpeg(name: imageName+"-texture", folder: "RT-Images")
                frame.sceneDepth?.depthMap.depth16BitImage?.savePNG(name: imageName+"-depth")
                frame.sceneDepth?.confidenceMap?.confidenceImage?.savePNG(name: imageName+"-confidence")
            }.store(in: &cancellable)
    }
}

extension ScanARViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let rotation = UIApplication.shared.orientation,
           frame.camera.trackingState == .normal {
            viewModel.rtabmap.postOdometryEvent(frame: frame, orientation: rotation, viewport: view.frame.size)
            self.arFrameReciever.send(frame)
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

