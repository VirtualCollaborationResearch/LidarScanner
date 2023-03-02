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

    @Published var scans = UserDefaults.scans
    var scanToBeSelected: Scan?

    init() {
        NotificationCenter.default.publisher(for: .exportResult).sink { [weak self] notif in
            if let self = self,
               let notif = notif.userInfo?["data"] as? NotifWrapper<Any?>,
               let scan = notif.wrappedValue as? Scan {
                self.scans.append(scan)
                UserDefaults.scans = self.scans
                self.uploadZip(scan: scan)
                self.createUsdz(scan: scan)
            }
        }.store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: .deleteScan).sink { [weak self] notif in
            if let notif = notif.userInfo?["data"] as? NotifWrapper<Any?>,
               let deleted = notif.wrappedValue as? Scan {
                self?.deleteWith(scan: deleted)
            }
        }.store(in: &cancellable)
    }
    
    func delete(i: IndexSet) {
            scans.remove(atOffsets: i)
            UserDefaults.scans = scans
    }
    
    func deleteWith(scan: Scan) {
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
    
    func createUsdz(scan:Scan) {
        if let url = scan.fileUrl(for: .obj) {
            print("** creating usdz")
            MDLAsset(url: url).convertToUsdz(objUrl: url,completion: nil)
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


