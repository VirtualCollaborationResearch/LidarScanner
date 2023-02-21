//
//  Coordinator.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 5.10.2022.
//

import Combine
import SwiftUI

@MainActor
class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    @Published var appLastUseState = UserDefaults.appLastUseState
    
    func returnToHomePage() {
        path.removeLast(path.count)
    }
    
    func areaListView() {
        path.append(Destination.areaListView)
    }
    
    func labelEditView() {
        path.append(Destination.labelEditView)
    }
    
    func modelViewer() {
        path.append(Destination.modelViewer)
    }
    
    func menuView() {
        path.append(Destination.menuView)
    }
    
    func returnToScanView() {
        appLastUseState = .scanMode
    }
    
    func goToHomeAreas() {
        UserDefaults.appLastUseState = .homeAreas
        appLastUseState = .homeAreas

    }
    
    func goToLabelView() {
        UserDefaults.appLastUseState = .navigateMode
        appLastUseState = .navigateMode
    }
    
    func tapOnSecondPage() {
        path.removeLast()
    }
}
