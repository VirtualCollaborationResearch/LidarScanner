//
//  SettingsView.swift
//  LidarScanner
//
//  Created by Oğuz Öztürk on 22.03.2023.
//

import SwiftUI

struct SettigsView:View {
    @State var text = "\(Int(UserDefaults.fps))"
    @State var isSmoothedDepthEnabled = UserDefaults.isSmoothed
    var body: some View {
        List {
            HStack {
                Text("FPS")
                
                Spacer()
                
                TextField("FPS", text: $text)
                    .keyboardType(.default)
                    .submitLabel(.done)
                    .onSubmit {
                        if let fps = Double(text) {
                            UserDefaults.fps = fps
                        }
                    }
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 100)
            }
            
            HStack {
                
                Toggle("Smoothed Depth", isOn: $isSmoothedDepthEnabled)
            }
        }
        .navigationTitle("Settings")
        .onChange(of: isSmoothedDepthEnabled) { newValue in
            UserDefaults.isSmoothed = newValue
        }
    }
}
