//
//  ScanListViewModel.swift
//  RTABMapApp
//
//  Created by Oğuz Öztürk on 22.02.2023.
//

import Foundation
import Combine
import FirebaseStorage
import SceneKit.ModelIO
import Zip

@MainActor
final class ScanListViewModel:ObservableObject {
    
    private var cancellable = Set<AnyCancellable>()
    
    @Published var scans = UserDefaults.scans.sorted { $0.dateStr > $1.dateStr }
    var scanToBeSelected: Scan?
    
    init() {
        NotificationCenter.default.publisher(for: .scanToBeSaved).sink { [weak self] notif in
            if let self = self,
               let notif = notif.userInfo?["data"] as? NotifWrapper<Any?>,
               let scan = notif.wrappedValue as? Scan {
                self.scans.insert(scan, at: 0)
                UserDefaults.scans = self.scans
                self.uploadZip(scan: scan)
                self.createUsdz(scan: scan)
                self.uploadRawData(scan: scan)
            }
        }.store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: .deleteScan).sink { [weak self] notif in
            if let notif = notif.userInfo?["data"] as? NotifWrapper<Any?>,
               let deleted = notif.wrappedValue as? Scan {
                self?.deleteWith(scan: deleted)
            }
        }.store(in: &cancellable)
    }
    
    func deleteFromFirebase(_ scan:Scan?) {
        if let scan = scan {
            FirebaseUploader.shared.remove(date: scan.dateStr, scanId: scan.id)
        }
    }
    
    func deleteFromFileManager(_ scan:Scan?) {
        if let folder = scan?.folderUrl {
            try? FileManager.default.removeItem(at: folder)
        }
    }
    
    func delete(i: IndexSet) {
        i.forEach {
            deleteFromFirebase(scans[safe:$0])
            deleteFromFileManager(scans[safe:$0])
        }
        scans.remove(atOffsets: i)
        UserDefaults.scans = scans
    }
    
    func deleteWith(scan: Scan) {
        deleteFromFirebase(scan)
        deleteFromFileManager(scan)
        scans.remove(object: scan)
        UserDefaults.scans = scans
    }
    
    func updateScan(name:String) {
        if !name.isBlank,
           let scanIndex = scans.firstIndex(where: { $0.id == self.scanToBeSelected?.id }) {
            scans[scanIndex].name = name
            UserDefaults.scans[scanIndex].name = name
        }
    }
    
    func uploadRawData(scan:Scan) {
        if let scanFolder = scan.folderUrl {
            let rawFolder = scanFolder.appendingPathComponent("RawData")
            if FileManager.default.fileExists(atPath: rawFolder.relativePath) {
                let zipUrl = scanFolder.appendingPathComponent("\(scan.dateStr)-raw.zip")
                do {
                    try Zip.zipFiles(paths: [rawFolder], zipFilePath: zipUrl, password: nil, progress: { progress in
                        if progress == 1 {
                            try? FileManager.default.removeItem(at: rawFolder)
                            FirebaseUploader.shared.upload(zipUrl: zipUrl,scanId: scan.id)
                        }
                    })
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func createUsdz(scan:Scan) {
        if let url = scan.fileUrl(for: .obj) {
            autoreleasepool {
                let asset = MDLAsset(url: url)
                asset.convertToUsdz(objUrl: url,completion: nil)
            }
        }
    }
    
    func uploadZip(scan:Scan) {
        if let obj = scan.fileUrl(for: .obj),
           let mtl = scan.fileUrl(for: .mtl),
           let jpg = scan.fileUrl(for: .jpg) {
            let exportDir = obj.deletingLastPathComponent()
            let zipUrl = exportDir.appendingPathComponent("\(scan.dateStr).zip")
            do {
                try Zip.zipFiles(paths: [obj,mtl,jpg], zipFilePath: zipUrl, password: nil, progress: { progress in
                    if progress == 1 {
                        FirebaseUploader.shared.upload(zipUrl: zipUrl,scanId: scan.id)
                    }
                })
            } catch {
                print(error)
            }
        }
    }
}


