//
//  MenuView.swift
//  Scanner-iOS
//
//  Created by Oğuz Öztürk on 5.10.2022.
//

import SwiftUI

enum MenuItems:Hashable {  case about,contact }

struct MenuView:View {
    
    @State private var selection: MenuItems?
    @State private var columnVisibility:NavigationSplitViewVisibility = .doubleColumn
    @Environment(\.presentationMode) var presentationMode
    var isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection:$selection) {
                    
                    Section("About Scanner") {
                        Text("About Us").tag(MenuItems.about)
                        Text("Contact Us").tag(MenuItems.contact)
                    }
                }
            .toolbar {
                ToolbarItem(placement:isPad ? .navigationBarTrailing : .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName:isPad ? "xmark" : "chevron.left")
                            .font(.system(size: 15))
                    }
                }
            }
            .navigationTitle("Menu")
        } detail: {
            switch selection {
            case .about:
                AboutView()
            default:
                ContactUsView()
            }
        }
        .navigationSplitViewStyle(.balanced)
        .toolbar(.hidden)
    }
}
