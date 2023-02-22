//
//  ScanListViewModel.swift
//  RTABMapApp
//
//  Created by Oğuz Öztürk on 22.02.2023.
//

import Foundation
import Combine

@MainActor
final class ScanListViewModel:ObservableObject {
    
    private var cancellable = Set<AnyCancellable>()

    @Published var scans = UserDefaults.scans
    var scanToBeSelected: Scan?
    
    init() {
        NotificationCenter.default.publisher(for: .exportResult).sink { [weak self] _ in
            self?.scans = UserDefaults.scans
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
}

