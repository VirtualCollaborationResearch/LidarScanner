//
//  ScanView.swift
//  HomeTwin-iOS
//
//  Created by Hatice Nur OKUR on 31.10.2022.
//

import SwiftUI
import ARKit

struct ScanView: View {
    @StateObject var viewModel = ScanViewViewModel()
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
                ScanARViewRepresentable(viewModel: viewModel).edgesIgnoringSafeArea(.all)
            } else {
                Text("This device not supported")
                    .frame(maxHeight: .infinity)
            }
            
            Button {
                viewModel.doneTapped()
            } label: {
                ScanViewButtons(imageName:"checkmark")
            }
            .accessibilityLabel("Complete scanning")
            
            if !viewModel.isScanning {
                
                Color.black.edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
                
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            
        }.toolbar {
            ToolbarItem(placement:.navigationBarLeading) {
                Button {
                    viewModel.rtabmap.cancelProcessing()
                    NotificationCenter.default.send(.pauseSession)
                    coordinator.goToHomeAreas()
                } label: {
                    ScanViewButtons(imageName: "xmark")
                }.accessibilityLabel("Return to map list")
            }
        }
        .onReceive(viewModel.doneScanning) { _ in
            coordinator.goToHomeAreas()
        }
    }
}


