//
//  ObjViewer.swift
//  RTABMapApp
//
//  Created by Oğuz Öztürk on 22.02.2023.
//

import UIKit
import SwiftUI
import SceneKit

class ObjViewModel: NSObject, ObservableObject {
    var scan:Scan
    
    init(scan:Scan) {
        self.scan = scan
        super.init()

    }
}

struct ObjViewer:View {
    @StateObject var viewModel:ObjViewModel
    
    var body: some View {
        ModelScene(url: viewModel.scan.fileUrl(for: .obj))
            .navigationTitle(viewModel.scan.dateStr)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement:.navigationBarTrailing) {
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
