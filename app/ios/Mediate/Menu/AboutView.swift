//
//  AboutView.swift
//  Scanner-iOS
//
//  Created by Oğuz Öztürk on 29.12.2022.
//

import SwiftUI
import StoreKit

struct AboutView : View {
    @State var copyrightActive = false
    @Environment(\.presentationMode) var presentation
    var body: some View {
        Form {
            Group() {
                Section() {
                    MenuItemNav(link:"https://www.mediate.tech", text:"About Us", image:"info.circle")
                    MenuItemNav(link:"https://www.mediate.tech/policies", text:"Terms and Conditions", image:"doc.on.doc")
                    MenuItemNav(link:"https://www.mediate.tech/policies", text:"Privacy Policy", image:"doc.on.doc")
                    NavigationLink(destination: CopyrightAndLicensesView()) {
                        MenuItem(iconName: "c.circle", title: "Copyright and Licenses")
                    }
                
                    
                }.accessibilityElement(children: .contain)
            }
        }
        .onAppear(perform: {
            //FirebaseAnalyticsReporter.shared.report(AEMenuViewAboutTapped())
        })
        .navigationBarTitle(Text("About"))
    }
}

struct AccessibleText: View {
    var text:String
    var body: some View {
        Text(text)
            .font(.system(size: 15))
            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
            .accessibility(label: Text(text))
    }
}

struct MenuItemNav: View {
    let link:String
    let text:String
    let image:String
    var body: some View {
        HStack {
            Image(systemName: image)
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(Color(.systemGray))
                .accessibility(hidden: true)
            
            AccessibleText(text:text)
            Spacer()
        }.onTapGesture() {
            guard let url = URL(string: link) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }.contentShape(Rectangle())
        .padding([.top , .bottom] , 5)
        .accessibility(hint: Text("Double tap to open \(text)"))
    }
}

struct MenuItem: View {
    var iconName: String
    var title: String
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .frame(width: 30, height: 30, alignment: .center)
                .accessibility(hidden: true)
                .foregroundColor(Color(.systemGray))

            Text(title)
                .font(.system(size: 15))

            Spacer()
        }
            .accessibilityElement(children: .ignore)
            .accessibility(label: Text("\(title)"))
            .accessibility(hint: Text("Double tap to open \(title) screen"))
    }
}
