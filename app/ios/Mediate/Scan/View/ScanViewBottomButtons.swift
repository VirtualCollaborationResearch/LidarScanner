//
//  ScanViewBottomButtons.swift
//  HomeTwin-iOS
//
//  Created by Hatice Nur OKUR on 31.10.2022.
//

import SwiftUI
import ARKit

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
