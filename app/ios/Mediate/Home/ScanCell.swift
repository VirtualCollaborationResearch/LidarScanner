//
//  ScanCell.swift
//  3DScanner
//
//  Created by Oğuz Öztürk on 27.02.2023.
//

import SwiftUI

struct ScanCell:View {
    var scan:Scan
    @State private var isUploading = false
    @State private var percentage = ""
    var body: some View {
            HStack(spacing:15) {
                ZStack {
                    AsyncImage(url: scan.id.uuidString.imageFromDisk("Map Images")) { image in
                        image.resizable()
                    } placeholder: {
                        Color(.systemGray4)
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .opacity(isUploading ? 0.6 : 1)
                    
                    if isUploading {
                        VStack(spacing:5) {
                            Text(percentage)
                                .font(.system(size: 16))
                            Text("Uploading")
                                .font(.system(size: 11))
                        }
                        .foregroundColor(.white)
                    }
                }
                
                VStack(alignment:.leading,spacing:5) {
                    Text(scan.name ?? scan.id.uuidString)
                        .font(.system(size: 16,weight: .semibold))
                        .lineLimit(1)

                    VStack(alignment:.leading) {
                        Text("Created at \(scan.dateStr)")
                    }
                    .foregroundColor(Color(.systemGray2))

                }
                .font(.system(size: 15))

                Spacer()
            }
            .contentShape(Rectangle())
            .onReceive(FirebaseUploader.shared.percentage) { result in
                guard scan.id == result.1 else { return }
                let value = result.0
                self.percentage = "%\(String(format: "%.f", value))"
                
                if value < 10 && !isUploading {
                    isUploading = true
                } else if value == 100 && isUploading {
                    isUploading = false
                    percentage = ""
                }
            }
    }
}
