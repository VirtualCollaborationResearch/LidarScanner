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

final class ScanARViewController: UIViewController {
    
    private var viewModel:ScanViewViewModel
    
    private var arView: ScanARView { self.view as! ScanARView }
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
                    image?.saveJpeg(name: "cover", folder: viewModel.scanId.uuidString)
                    saveWorldMap()
                    arView.stopScanning()
                    viewModel.rtabmap.stop()
                })
            }
        }.store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: .pauseSession, object: nil).sink {  [weak self] _ in
            self?.arView.stopScanning()
        }.store(in: &cancellable)
        
        arFrameReciever
            .throttle(for: .seconds(1/UserDefaults.fps), scheduler: DispatchQueue.global(), latest: true)
            .sink { [weak self] frame in
                self?.viewModel.saveRawData(frame: frame)
            }.store(in: &cancellable)
    }
    
    private func saveWorldMap() {
        let scanId = viewModel.scanId
        arView.session.getCurrentWorldMap { (worldMap, error) in
            if let map: ARWorldMap = worldMap,
               error == nil,
                let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true) {
                    let savedMap = UserDefaults.standard
                    savedMap.set(data, forKey: "Map_" + scanId.uuidString)
                    savedMap.synchronize()
                NotificationCenter.default.send(.mapSaved,ScanViewAlertTypes.mapSaved)
            } else {
                NotificationCenter.default.send(.mapSaved,ScanViewAlertTypes.errorWhileSavingMap)
            }
        }
    }
    
//    private func saveCorrectedCameras() {
//        let folder = "\(viewModel.scanId)/RawData/"
//        if  let camera = arView.session.currentFrame?.camera {
//            arView.session.currentFrame?.anchors.forEach { anchor in
//                if let name = anchor.name, name.contains("camera-") == true {
//                    let timeStamp = name.split(separator: "-").last ?? "\(UUID().uuidString)"
//                    let model = CameraModel(camera: camera,anchor:anchor, timeStamp: Double(timeStamp) ?? 0)
//                    model.writeToDisk(name: String(timeStamp),folder: folder+"correctedCamera")
//                }
//            }
//        }
//    }
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

