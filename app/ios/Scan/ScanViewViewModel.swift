//
//  ScanViewViewModel.swift
//  HomeTwin-iOS
//
//  Created by Hatice Nur OKUR on 31.10.2022.
//

import Foundation
import Combine
import SwiftUI
import ARKit

final class ScanViewViewModel:ObservableObject {
    
    private var cancellable = Set<AnyCancellable>()
    
    var reset = PassthroughSubject<Bool,Never>()
    var snapShot = PassthroughSubject<UUID,Never>()
    var isLightingSufficient = CurrentValueSubject<Bool,Never>(false)
    @Published var isScanning = true
    var openedDatabasePath:URL?
    
    var rtabmap = RTABMap()

    init() {
        setupNotificationListener()
    }
    
    private func setupNotificationListener() {
        NotificationCenter.default.publisher(for: .toggleSheet).sink {  [weak self] _ in
            
        }.store(in: &cancellable)
    }
    
    func resetTapped() {
        reset.send(true)
    }
    
    func doneTapped() {
        snapShot.send(UUID())
        isScanning = false
        rtabmap.setPausedMapping(paused: true)
        rtabmap.stopCamera()
        rtabmap.setLocalizationMode(enabled: false)
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
            
           let success = self.rtabmap.exportMesh(
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
                            self.rtabmap.setMeshRendering(enabled: false, withTexture: false)
                        } else if(!isOBJ) {
                            self.rtabmap.setMeshRendering(enabled: true, withTexture: false)
                        } else {
                            self.rtabmap.setMeshRendering(enabled: true, withTexture: true)// isOBJ
                        }
                        
                        self.rtabmap.postExportation(visualize: true)

                        if self.openedDatabasePath == nil {
                          //  self.save()
                        }
                })
    }
    
//    func save()
//    {
//        //Step : 1
//        let alert = UIAlertController(title: "Save Scan", message: "RTAB-Map Database Name (*.db):", preferredStyle: .alert )
//        //Step : 2
//        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
//            let textField = alert.textFields![0] as UITextField
//            if textField.text != "" {
//                //Read TextFields text data
//                let fileName = textField.text!+".db"
//                let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName).path
//                if FileManager.default.fileExists(atPath: filePath) {
//                    let alert = UIAlertController(title: "File Already Exists", message: "Do you want to overwrite the existing file?", preferredStyle: .alert)
//                    let yes = UIAlertAction(title: "Yes", style: .default) {
//                        (UIAlertAction) -> Void in
//                        self.saveDatabase(fileName: fileName);
//                    }
//                    alert.addAction(yes)
//                    let no = UIAlertAction(title: "No", style: .cancel) {
//                        (UIAlertAction) -> Void in
//                    }
//                    alert.addAction(no)
//
//                    self.present(alert, animated: true, completion: nil)
//                } else {
//                    self.saveDatabase(fileName: fileName);
//                }
//            }
//        }
//
//        //Step : 3
//        var placeholder = Date().getFormattedDate(format: "yyMMdd-HHmmss")
//        if self.openedDatabasePath != nil && !self.openedDatabasePath!.path.isEmpty
//        {
//            var components = self.openedDatabasePath!.lastPathComponent.components(separatedBy: ".")
//            if components.count > 1 { // If there is a file extension
//                components.removeLast()
//                placeholder = components.joined(separator: ".")
//            } else {
//                placeholder = self.openedDatabasePath!.lastPathComponent
//            }
//        }
//        alert.addTextField { (textField) in
//                textField.text = placeholder
//        }
//
//        //Step : 4
//        alert.addAction(save)
//        //Cancel action
//        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })
//
//        self.present(alert, animated: true) {
//            alert.textFields?.first?.selectAll(nil)
//        }
//    }
//
//    func saveDatabase(fileName: String)
//    {
//        let filePath = self.getDocumentDirectory().appendingPathComponent(fileName).path
//
//        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
//        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 60.0)
//        indicator.center = view.center
//        view.addSubview(indicator)
//        indicator.bringSubviewToFront(view)
//
//        indicator.startAnimating()
//
//        let previousState = mState;
//        updateState(state: .STATE_PROCESSING);
//
//        DispatchQueue.background(background: {
//            self.rtabmap?.save(databasePath: filePath); // save
//        }, completion:{
//            // main thread
//            indicator.stopAnimating()
//            indicator.removeFromSuperview()
//
//            self.openedDatabasePath = URL(fileURLWithPath: filePath)
//
//            let alert = UIAlertController(title: "Database saved!", message: String(format: "Database \"%@\" successfully saved!", fileName), preferredStyle: .alert)
//            let yes = UIAlertAction(title: "OK", style: .default) {
//                (UIAlertAction) -> Void in
//            }
//            alert.addAction(yes)
//            self.present(alert, animated: true, completion: nil)
//            do {
//                let tmpDatabase = self.getDocumentDirectory().appendingPathComponent(self.RTABMAP_TMP_DB)
//                try FileManager.default.removeItem(at: tmpDatabase)
//            }
//            catch {
//                print("Could not clear tmp database: \(error)")
//            }
//            self.updateDatabases()
//            self.updateState(state: previousState)
//        })
//    }
//
}



