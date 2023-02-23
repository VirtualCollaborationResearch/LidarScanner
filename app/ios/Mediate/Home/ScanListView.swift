//
//  ScanListView.swift
//  RTABMapApp
//
//  Created by Oğuz Öztürk on 22.02.2023.
//

import SwiftUI

struct ScanListView:View {
    
    @StateObject var viewModel = ScanListViewModel()
    @EnvironmentObject var coordinator: Coordinator
    @State private var renameAlert = false
    @State private var scanName = ""
    var body: some View {
        let isEmpty = viewModel.scans.isEmpty
        ZStack(alignment:.bottomTrailing) {
            List {
                if isEmpty {
                    EmptyScansView().environmentObject(coordinator)
                } else {
                    ForEach(viewModel.scans, id:\.id) { scan in
                        ZStack(alignment:.topTrailing) {
                            HStack(spacing:15) {
                                AsyncImage(url: scan.id.uuidString.imageFromDisk("Map Images")) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color(.systemGray4)
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
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
                            .onTapGesture {
                                coordinator.modelViewer(scan: scan)
                            }
                            
                            Menu {
                                Button {
                                    viewModel.scanToBeSelected = scan
                                    renameAlert.toggle()
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive) {
                                    withAnimation {
                                        viewModel.deleteWith(scan: scan)
                                    }
                                } label: {
                                    Label("Remove", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.gray)
                                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 6, trailing: 0))
                            }
                        }
                    }
                    .onDelete { i in
                        viewModel.delete(i: i)
                    }
                }
            }.zIndex(0)
            
            if !isEmpty {
                Button {
                    coordinator.goToScanView()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(.systemMint))
                }
                .accessibilityLabel("add new scan")
                .padding(.bottom,30)
                .padding(.trailing)
                .transition(.opacity)
                .zIndex(2)
            }
        }
        .alert("Change Scan Name", isPresented: $renameAlert, actions: {
            TextField(viewModel.scanToBeSelected?.name ?? "", text: $scanName)
            Button("OK", action: { viewModel.updateScan(name: scanName) })
            Button("Cancel", role: .cancel, action: {})
        })
        .toolbar {
             ToolbarItem(placement:.navigationBarTrailing) {
                     Button {
                         coordinator.menuView()
                     } label: {
                         Image(systemName: "line.3.horizontal")
                             .font(.system(size: 15,weight: .semibold))
                     }.accessibilityLabel("Menu")

             }
         }
        .navigationTitle("Scans")
    }
}


struct EmptyScansView:View {
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image("sampleModel")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 600,alignment: .center)
                    .padding()
                
                
                VStack(spacing:5) {
                    Text("You don't have any scans yet")
                        .font(.system(size: 16,weight: .bold))
                    Text("Click + to new scan")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }.padding(.bottom)
                
                
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Color(.systemMint))
                    .padding(4)
                    .background(Circle()
                        .fill(Color(.systemMint))
                        .opacity(0.1))
                    .padding()
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            coordinator.goToScanView()
        }
    }
}
