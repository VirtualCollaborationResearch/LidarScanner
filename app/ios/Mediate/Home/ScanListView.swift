//
//  ScanListView.swift
//  RTABMapApp
//
//  Created by Oğuz Öztürk on 22.02.2023.
//

import SwiftUI

struct ScanListView:View {
    
    @ObservedObject var viewModel = ScanListViewModel()
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        let isEmpty = viewModel.scans.isEmpty
        ZStack(alignment:.bottomTrailing) {
            List {
                if isEmpty {
                    EmptyScansView().environmentObject(coordinator)
                } else {
                    ForEach(viewModel.scans, id:\.id) { scan in
                        ZStack(alignment: .topTrailing) {
                            ScanCell(scan: scan)
                                .onTapGesture {
                                    coordinator.modelViewer(scan: scan)
                                }
                            
                            Menu {
                                Button {
                                    viewModel.scanToBeSelected = scan
                                    viewModel.showSheet.toggle()
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
        .sheet(isPresented: $viewModel.showSheet, content: {
            switch viewModel.sheetType {
            case .areaName:
                ScanNameView()
            }
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

