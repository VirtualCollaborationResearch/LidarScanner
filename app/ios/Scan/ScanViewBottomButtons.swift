//
//  ScanViewBottomButtons.swift
//  HomeTwin-iOS
//
//  Created by Hatice Nur OKUR on 31.10.2022.
//

import SwiftUI
import ARKit

struct ScanViewBottomButtons: View {
    @StateObject var viewModel: ScanViewViewModel
    @EnvironmentObject var coordinator: Coordinator
    @State private var isLightSufficient = false
    var body: some View {
        ZStack {
            if viewModel.isScanning {
                Text(isLightSufficient ? "" : "Poor Lighting...")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.vertical,5)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray).opacity(0.4))
                    .transition(.opacity)
                    .opacity(0)
            }
            
            HStack{
                if viewModel.isScanning {
                    Button {
                        viewModel.resetTapped()
                    } label: {
                        ScanViewButtons(imageName: "goforward")
                    }
                    .scaledToFit()
                    .accessibilityLabel("Reset scanning")
                    Spacer()
                }
                
                    Button {
                        viewModel.doneTapped()
                    } label: {
                        if viewModel.isScanning {
                            ScanViewButtons(imageName:"checkmark")
                        } else {
                            Text("Continue")
                        }
                    }
                    .scaledToFit()
                    .accessibilityLabel("Complete scanning")
                
            }
        }
        .padding(.bottom)
        .padding(.horizontal,10)
        .onReceive(viewModel.isLightingSufficient) { value in
            isLightSufficient = value
        }
    }
}

struct ScanViewButtons: View {
    
    var imageName: String
    var height: CGFloat = 40
    var fontSize:CGFloat = 16
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.gray)
                .opacity(0.4)
                .frame(height: height)
            
            
            Image(systemName: imageName)
                .font(.system(size: fontSize))
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}

struct LabelViewButtons: View {
    
    var imageName: String
    var height: CGFloat = 40
    var fontSize:CGFloat = 16
    @Binding var isSelected: Bool
    var body: some View {
        ZStack{
            Circle()
                .fill(isSelected ? Color.green : Color.gray)
                .opacity(0.4)
                .frame(height: height)
            
            
            Image(systemName: imageName)
                .font(.system(size: fontSize))
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}
