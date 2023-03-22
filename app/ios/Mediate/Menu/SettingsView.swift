//
//  SettingsView.swift
//  LidarScanner
//
//  Created by Oğuz Öztürk on 22.03.2023.
//

import SwiftUI

struct SettigsView:View {
    @State var text = "\(Int(UserDefaults.fps))"
    
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
        }
        .navigationTitle("Settings")
    }
}
