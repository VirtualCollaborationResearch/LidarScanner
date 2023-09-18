//
//  ModelScene.swift
//  RTABMapApp
//
//  Created by Oğuz Öztürk on 22.02.2023.
//

import UIKit
import SwiftUI
import SceneKit

struct ModelScene:View {
    @StateObject var viewModel:ModelSceneViewModel
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        ZStack(alignment:.bottomTrailing) {
            ModelSceneRepresentable(viewModel: viewModel)
                .zIndex(0)
            
            ForEach(viewModel.measures) { measure in
                if let dist = measure.distance {
                    HStack(spacing:10) {
                        Text(dist)
                         Image(systemName: "xmark")
                        
                    }
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical,5)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.5)))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.measures.remove(object: measure)
                        viewModel.cleanMeasure.send(measure.id)
                    }
                    .zIndex(1)
                    .position(measure.lineLocation ?? .zero)
                    .transition(.opacity)
                }
            }
        }
            .navigationTitle(viewModel.scan.dateStr)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement:.navigationBarTrailing) {
                    HStack {
                        Button("Load") {
                            coordinator.goToStreamView(scan: viewModel.scan)
                        }
                        
                        Menu {
                            
                            if let obj = viewModel.scan.fileUrl(for: .obj),
                               let mtl = viewModel.scan.fileUrl(for: .mtl),
                               let texture = viewModel.scan.fileUrl(for: .jpg) {
                                ShareLink( "Obj File", items: [obj,mtl,texture])
                            }
                            
                            if let usdz = viewModel.scan.fileUrl(for: .usdz) {
                                ShareLink( "USDZ File", item: usdz)
                            }
                            
                            if let usdz = viewModel.scan.fileUrl(for: .zip) {
                                ShareLink( "Zipped Obj", item: usdz)
                            }
                            
                            if let rawZip = viewModel.scan.fileUrl(for: .rawZip) {
                                ShareLink( "Zipped Raw Data", item: rawZip)
                            }
                            
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }
    }
}
