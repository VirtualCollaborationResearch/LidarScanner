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
            NavigationStack(path: $coordinator.path) {
                switch coordinator.appLastUseState {
                default:
                    ScanView()
                        .navigationDestination(for: Destination.self) { destination in
                            ViewFactory.viewForDestination(destination)
                        }
                }
            }
            .environmentObject(coordinator)
        }
    }
}

enum AppLastUseState:Codable {
    case firstOpen
    case homeAreas
    case scanMode
    case navigateMode
}
