//
//  StreamARView.swift
//  LidarScanner
//
//  Created by Oğuz Öztürk on 15.03.2023.
//

import SwiftUI
import ARKit

struct StreamARView: View {
    @StateObject var viewModel: StreamViewModel
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        ZStack(alignment: .bottom) {
            
            if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
                StreamARViewRepresentable(viewModel: viewModel).edgesIgnoringSafeArea(.all)
            } else {
                Text("This device not supported")
                    .frame(maxHeight: .infinity)
            }
            
            Button("Stop") {
                viewModel.isScanning.toggle()
            }
        }
    }
}

