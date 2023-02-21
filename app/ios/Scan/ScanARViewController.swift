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
import Zip

class ScanARViewController: UIViewController, RTABMapObserver {
    func progressUpdated(_ rtabmap: RTABMap, count: Int, max: Int) { }
    
    func initEventReceived(_ rtabmap: RTABMap, status: Int, msg: String) { }
    
    func statsUpdated(_ rtabmap: RTABMap, nodes: Int, words: Int, points: Int, polygons: Int, updateTime: Float, loopClosureId: Int, highestHypId: Int, databaseMemoryUsed: Int, inliers: Int, matches: Int, featuresExtracted: Int, hypothesis: Float, nodesDrawn: Int, fps: Float, rejected: Int, rehearsalValue: Float, optimizationMaxError: Float, optimizationMaxErrorRatio: Float, distanceTravelled: Float, fastMovement: Int, landmarkDetected: Int, x: Float, y: Float, z: Float, roll: Float, pitch: Float, yaw: Float) { }
    
        
    var viewModel:ScanViewViewModel

    var arView: ScanARView { self.view as! ScanARView }
    var rtabmap: RTABMap?

    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: ScanViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rtabmap = RTABMap()
        rtabmap?.setupCallbacksWithCPP()
        rtabmap!.addObserver(self)
        registerSettingsBundle()
        updateDisplayFromDefaults()

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
            if value {
                let tmpDatabase = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("rtabmap.tmp.db")
                let inMemory = UserDefaults.standard.bool(forKey: "DatabaseInMemory")
                self?.rtabmap?.openDatabase(databasePath: tmpDatabase.path, databaseInMemory: inMemory, optimize: false, clearDatabase: true)
                self?.rtabmap?.setCamera(type: 0)
                self?.rtabmap?.startCamera()
                self?.arView.startScanning()

            } else {
                self?.arView.session.pause()
                self?.rtabmap?.setPausedMapping(paused: true)
                self?.rtabmap?.stopCamera()
                self?.rtabmap?.setLocalizationMode(enabled: false)
                self?.optimization()
            }
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


extension ScanARViewController {
    private func optimization() {
        var loopDetected : Int = -1
        DispatchQueue.background(background: {
            loopDetected = self.rtabmap?.postProcessing(approach: -1) ?? -1
        }, completion:{
            if(loopDetected >= 0) {
                self.export(isOBJ: true, meshing: true, regenerateCloud: false, optimized: true, optimizedMaxPolygons: 200000)
            } else if(loopDetected < 0)  {
                print("oguz Optimization failed!")
            }
        })
    }
    
    private func export(isOBJ: Bool, meshing: Bool, regenerateCloud: Bool, optimized: Bool, optimizedMaxPolygons: Int) {
        let defaults = UserDefaults.standard
        let cloudVoxelSize = defaults.float(forKey: "VoxelSize")
        let textureSize = isOBJ ? defaults.integer(forKey: "TextureSize") : 0
        let textureCount = defaults.integer(forKey: "MaximumOutputTextures")
        let normalK = defaults.integer(forKey: "NormalK")
        let maxTextureDistance = defaults.float(forKey: "MaxTextureDistance")
        let minTextureClusterSize = defaults.integer(forKey: "MinTextureClusterSize")
        let optimizedVoxelSize = cloudVoxelSize
        let optimizedDepth = defaults.integer(forKey: "ReconstructionDepth")
        let optimizedColorRadius = defaults.float(forKey: "ColorRadius")
        let optimizedCleanWhitePolygons = defaults.bool(forKey: "CleanMesh")
        let optimizedMinClusterSize = defaults.integer(forKey: "PolygonFiltering")
        let blockRendering = false
        
        DispatchQueue.background(background: {
            
            let success = self.rtabmap?.exportMesh(
                cloudVoxelSize: cloudVoxelSize,
                regenerateCloud: regenerateCloud,
                meshing: meshing,
                textureSize: textureSize,
                textureCount: textureCount,
                normalK: normalK,
                optimized: optimized,
                optimizedVoxelSize: optimizedVoxelSize,
                optimizedDepth: optimizedDepth,
                optimizedMaxPolygons: optimizedMaxPolygons,
                optimizedColorRadius: optimizedColorRadius,
                optimizedCleanWhitePolygons: optimizedCleanWhitePolygons,
                optimizedMinClusterSize: optimizedMinClusterSize,
                optimizedMaxTextureDistance: maxTextureDistance,
                optimizedMinTextureClusterSize: minTextureClusterSize,
                blockRendering: blockRendering)
            
        }, completion:{
            
            if(!meshing && cloudVoxelSize>0.0)
            {
                print("Cloud assembled and voxelized at \(cloudVoxelSize) m.")
            }
            
            if(!meshing) {
                self.rtabmap?.setMeshRendering(enabled: false, withTexture: false)
            } else if(!isOBJ) {
                self.rtabmap?.setMeshRendering(enabled: true, withTexture: false)
            } else {
                self.rtabmap?.setMeshRendering(enabled: true, withTexture: true)// isOBJ
            }
            
            self.rtabmap?.postExportation(visualize: true)
            self.rtabmap?.setCamera(type: 2)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self.writeExportedFiles(fileName: "Export-\(UUID().uuidString)")
            }
        })
    }
    
    func writeExportedFiles(fileName: String) {
        let exportDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("Export")
        
        do {
            try FileManager.default.removeItem(at: exportDir)
        }
        catch
        {}
        
        do {
            try FileManager.default.createDirectory(at: exportDir, withIntermediateDirectories: true)
        }
        catch
        {
            print("Failed adding export directory \(exportDir)")
            return
        }
        
        var zipFileUrl : URL!
        
        print("Exporting to directory \(exportDir.path) with name \(fileName)")
        if(self.rtabmap?.writeExportedMesh(directory: exportDir.path, name: fileName)) == true
        {
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: exportDir, includingPropertiesForKeys: nil)
                if(!fileURLs.isEmpty)
                {
                    do {
                        zipFileUrl = try Zip.quickZipFiles(fileURLs, fileName: fileName) // Zip
                        print("Zip file \(zipFileUrl.path) created (size=\(zipFileUrl.fileSizeString)")
                    }
                    catch {
                        print("Something went wrong while zipping")
                    }
                }
            } catch {
                print("No files exported to \(exportDir)")
                return
            }
        }
    }
    
    func getMemoryUsage() -> UInt64 {
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        if kerr == KERN_SUCCESS {
            return taskInfo.resident_size / (1024*1024)
        }
        else {
            print("Error with task_info(): " +
                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
            return 0
        }
    }
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    func updateDisplayFromDefaults()
    {
        //Get the defaults
        let defaults = UserDefaults.standard
 
        //let appendMode = defaults.bool(forKey: "AppendMode")
        
        // update preference
        rtabmap!.setOnlineBlending(enabled: defaults.bool(forKey: "Blending"));
        rtabmap!.setNodesFiltering(enabled: defaults.bool(forKey: "NodesFiltering"));
        rtabmap!.setRawScanSaved(enabled: defaults.bool(forKey: "SaveRawScan"));
        rtabmap!.setFullResolution(enabled: defaults.bool(forKey: "HDMode"));
        rtabmap!.setSmoothing(enabled: defaults.bool(forKey: "Smoothing"));
        rtabmap!.setAppendMode(enabled: defaults.bool(forKey: "AppendMode"));
        
        // Mapping parameters
        rtabmap!.setMappingParameter(key: "Rtabmap/DetectionRate", value: defaults.string(forKey: "UpdateRate")!);
        rtabmap!.setMappingParameter(key: "Rtabmap/TimeThr", value: defaults.string(forKey: "TimeLimit")!);
        rtabmap!.setMappingParameter(key: "Rtabmap/MemoryThr", value: defaults.string(forKey: "MemoryLimit")!);
        rtabmap!.setMappingParameter(key: "RGBD/LinearSpeedUpdate", value: defaults.string(forKey: "MaximumMotionSpeed")!);
        let motionSpeed = ((defaults.string(forKey: "MaximumMotionSpeed")!) as NSString).floatValue/2.0;
        rtabmap!.setMappingParameter(key: "RGBD/AngularSpeedUpdate", value: NSString(format: "%.2f", motionSpeed) as String);
        rtabmap!.setMappingParameter(key: "Rtabmap/LoopThr", value: defaults.string(forKey: "LoopClosureThreshold")!);
        rtabmap!.setMappingParameter(key: "Mem/RehearsalSimilarity", value: defaults.string(forKey: "SimilarityThreshold")!);
        rtabmap!.setMappingParameter(key: "Kp/MaxFeatures", value: defaults.string(forKey: "MaxFeaturesExtractedVocabulary")!);
        rtabmap!.setMappingParameter(key: "Vis/MaxFeatures", value: defaults.string(forKey: "MaxFeaturesExtractedLoopClosure")!);
        rtabmap!.setMappingParameter(key: "Vis/MinInliers", value: defaults.string(forKey: "MinInliers")!);
        rtabmap!.setMappingParameter(key: "RGBD/OptimizeMaxError", value: defaults.string(forKey: "MaxOptimizationError")!);
        rtabmap!.setMappingParameter(key: "Kp/DetectorStrategy", value: defaults.string(forKey: "FeatureType")!);
        rtabmap!.setMappingParameter(key: "Vis/FeatureType", value: defaults.string(forKey: "FeatureType")!);
        rtabmap!.setMappingParameter(key: "Mem/NotLinkedNodesKept", value: defaults.bool(forKey: "SaveAllFramesInDatabase") ? "true" : "false");
        rtabmap!.setMappingParameter(key: "RGBD/OptimizeFromGraphEnd", value: defaults.bool(forKey: "OptimizationfromGraphEnd") ? "true" : "false");
        rtabmap!.setMappingParameter(key: "RGBD/MaxOdomCacheSize", value: defaults.string(forKey: "MaximumOdometryCacheSize")!);
        rtabmap!.setMappingParameter(key: "Optimizer/Strategy", value: defaults.string(forKey: "GraphOptimizer")!);
        rtabmap!.setMappingParameter(key: "RGBD/ProximityBySpace", value: defaults.string(forKey: "ProximityDetection")!);

        let markerDetection = defaults.integer(forKey: "ArUcoMarkerDetection")
        if(markerDetection == -1)
        {
            rtabmap!.setMappingParameter(key: "RGBD/MarkerDetection", value: "false");
        }
        else
        {
            rtabmap!.setMappingParameter(key: "RGBD/MarkerDetection", value: "true");
            rtabmap!.setMappingParameter(key: "Marker/Dictionary", value: defaults.string(forKey: "ArUcoMarkerDetection")!);
            rtabmap!.setMappingParameter(key: "Marker/CornerRefinementMethod", value: (markerDetection > 16 ? "3":"0"));
            rtabmap!.setMappingParameter(key: "Marker/MaxDepthError", value: defaults.string(forKey: "MarkerDepthErrorEstimation")!);
            if let val = NumberFormatter().number(from: defaults.string(forKey: "MarkerSize")!)?.doubleValue
            {
                rtabmap!.setMappingParameter(key: "Marker/Length", value: String(format: "%f", val/100.0))
            }
            else{
                rtabmap!.setMappingParameter(key: "Marker/Length", value: "0")
            }
        }

        // Rendering
        rtabmap!.setCloudDensityLevel(value: defaults.integer(forKey: "PointCloudDensity"));
        rtabmap!.setMaxCloudDepth(value: defaults.float(forKey: "MaxDepth"));
        rtabmap!.setMinCloudDepth(value: defaults.float(forKey: "MinDepth"));
        rtabmap!.setDepthConfidence(value: defaults.integer(forKey: "DepthConfidence"));
        rtabmap!.setPointSize(value: defaults.float(forKey: "PointSize"));
        rtabmap!.setMeshAngleTolerance(value: defaults.float(forKey: "MeshAngleTolerance"));
        rtabmap!.setMeshTriangleSize(value: defaults.integer(forKey: "MeshTriangleSize"));
        rtabmap!.setMeshDecimationFactor(value: defaults.float(forKey: "MeshDecimationFactor"));
        let bgColor = defaults.float(forKey: "BackgroundColor");
        rtabmap!.setBackgroundColor(gray: bgColor);
        
    
        rtabmap!.setClusterRatio(value: defaults.float(forKey: "NoiseFilteringRatio"));
        rtabmap!.setMaxGainRadius(value: defaults.float(forKey: "ColorCorrectionRadius"));
        rtabmap!.setRenderingTextureDecimation(value: defaults.integer(forKey: "TextureResolution"));
        
    }
}
