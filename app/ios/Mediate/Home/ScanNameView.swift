//
//  ScanNameView.swift
//  HomeTwin-iOS
//
//  Created by Hatice Nur OKUR on 31.10.2022.
//

import SwiftUI

struct ScanNameView: View {
    
    @State private var areaName: String =  ""
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var keyboardFocused: Bool
    
    var body: some View {
        VStack(spacing: 100){
            TextField("Scan Name", text: self.$areaName)
                .focused($keyboardFocused)
                .submitLabel(.done)
                .lineSpacing(8)
                .font(.system(size: 25))
                .padding(.horizontal)
                .onChange(of: areaName) { value in
                    print("DEBUG: ", areaName)
                }
            
            Button {
                continueButtonTapped()
            } label: {
                Text("Continue")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .padding(.horizontal,25)
                    .padding(.vertical,8)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.accentColor))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                keyboardFocused = true
            }
        }
    }
    
    
    func continueButtonTapped() {
        if !areaName.isBlank {
            NotificationCenter.default.post(name: .scanName, object: nil,userInfo: ["data":areaName])
        }
        presentationMode.wrappedValue.dismiss()
    }
}
