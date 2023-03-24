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
            
            StreamRTCConnectionView(signalingClient: viewModel.signalingClient)
            
        }
        .toolbar {
            ToolbarItem(placement:.navigationBarTrailing) {
                    Button("Stream") {
                        viewModel.signalingClient.sendOffer()
                    }
            }
        }
    }
}

struct StreamRTCConnectionView:View {
    var signalingClient: SignalingClient
    @State private var connection = ""
    @State private var connectionColor = Color.white
    @State private var errorState = ""

    var body: some View {
        VStack(spacing:5) {
            Text(connection)
                .font(.system(size: 15,weight: .semibold))
                .foregroundColor(connectionColor)

            Text(errorState)
                .font(.system(size: 12))
                .italic()
                .foregroundColor(.white)
                .opacity(0.7)
        }
        .onReceive(signalingClient.connectionState) { state in
            connection = state.description
            connectionColor = Color(state.color)
        }
        .onReceive(signalingClient.errorState) { error in
            if !connection.isEmpty {
                 errorState = error.rawValue
            }
        }
    }
}
