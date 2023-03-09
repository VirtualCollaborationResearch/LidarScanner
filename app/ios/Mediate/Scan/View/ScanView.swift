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
                ScanCreationLoading(viewModel: viewModel)
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
        .onReceive(viewModel.scanResult) { scan in
            coordinator.goToHomeAreas()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                NotificationCenter.default.send(.scanToBeSaved,scan)
            }
        }
    }
}

struct ScanCreationLoading:View {
    
    @State private var percentage:Float = 0
    @StateObject var viewModel:ScanViewViewModel
    
    var body: some View {
        ZStack {
            Color.black
            
            VStack(alignment:.center) {
                Spacer()
                ProgressView(value: percentage, total: 100) {
                    HStack {
                        Text("Creating model...")
                        Spacer()
                        Text("%\(Int(percentage))")
                    }
                }
                .tint(.accentColor)
                .padding()
                Spacer()
            }
            .frame(maxWidth: 500)
        }
        .edgesIgnoringSafeArea(.all)
        .onReceive(viewModel.modelCreationPercentage) { result in
            self.percentage = result
        }
    }
}
