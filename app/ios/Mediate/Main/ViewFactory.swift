//
//  ViewFactory.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 5.10.2022.
//

import Foundation
import SwiftUI

class ViewFactory {
    @ViewBuilder
    static func viewForDestination(_ destination: Destination) -> some View {
        switch destination {
        case .modelViewer(let scan):
            ModelScene(viewModel: .init(scan: scan))
        case .menuView:
            MenuView()
        case .streamView(let scan):
            StreamARView(viewModel: .init(scan:scan))
        default:
            ScanView()
        }
    }
}
