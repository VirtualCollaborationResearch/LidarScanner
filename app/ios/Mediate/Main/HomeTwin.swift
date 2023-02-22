//
//  HomeTwin_iOSApp.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 3.10.2022.
//

import SwiftUI

@main
struct HomeTwin: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            if coordinator.isScanning {
                NavigationStack(path: $coordinator.path) {
                    ScanView()
                        .navigationDestination(for: Destination.self) { destination in
                            ViewFactory.viewForDestination(destination)
                        }
                }
                .environmentObject(coordinator)
            } else {
                NavigationStack(path: $coordinator.path) {
                    ScanListView()
                        .navigationDestination(for: Destination.self) { destination in
                            ViewFactory.viewForDestination(destination)
                        }
                }
                .environmentObject(coordinator)
            }
        }
    }
}
