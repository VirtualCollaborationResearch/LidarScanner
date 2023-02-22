//
//  CopyrightAndLicensesView.swift
//  Scanner-iOS
//
//  Created by Oğuz Öztürk on 29.12.2022.
//

import SwiftUI

struct CopyrightAndLicensesView : View {
    
    var licanses : [LicansesModel] = []
    
    init() {
        
        let normalAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let boldAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        
        let underlineAttributes: [NSAttributedString.Key: Any] = [.underlineStyle : NSUnderlineStyle.single.rawValue]
        
        let boldFreepikString = NSAttributedString(string: " \n www.freepik.com", attributes: boldAttributes)
        
        let boldRawPixelString = NSAttributedString(string: " \n www.rawpixel.com", attributes: boldAttributes)
        
        
        let techLicanse = NSMutableAttributedString(string: "Technology", attributes: underlineAttributes)
        let createdBy = NSAttributedString(string: " vector created by ", attributes: normalAttributes)
        let creator = NSAttributedString(string: "pch.vector ", attributes: boldAttributes)
        
        techLicanse.append(createdBy)
        techLicanse.append(creator)
        techLicanse.append(boldFreepikString)
        
        
        
        let backgroundLicanse = NSMutableAttributedString(string: "Background", attributes: underlineAttributes)
        
        let creator2 = NSAttributedString(string: "redgreystock ", attributes: boldAttributes)
        
        backgroundLicanse.append(createdBy)
        backgroundLicanse.append(creator2)
        backgroundLicanse.append(boldFreepikString)
        
        let clockLicanse = NSMutableAttributedString(string: "Clock", attributes: underlineAttributes)
        
        let creator3 = NSAttributedString(string: "freepik ", attributes: boldAttributes)
        
        clockLicanse.append(createdBy)
        clockLicanse.append(creator3)
        clockLicanse.append(boldFreepikString)
        
        let schoolLicanse = NSMutableAttributedString(string: "School", attributes: underlineAttributes)
        
        let creator4 = NSAttributedString(string: "pch.vector ", attributes: boldAttributes)
        
        schoolLicanse.append(createdBy)
        schoolLicanse.append(creator4)
        schoolLicanse.append(boldFreepikString)
        
        let crowdLicanse = NSMutableAttributedString(string: "Crowd", attributes: underlineAttributes)
        
        let creator5 = NSAttributedString(string: "freepik ", attributes: boldAttributes)
        
        crowdLicanse.append(createdBy)
        crowdLicanse.append(creator5)
        crowdLicanse.append(boldRawPixelString)
        
        let businessLicanse = NSMutableAttributedString(string: "Business", attributes: underlineAttributes)
        
        let creator6 = NSAttributedString(string: "freepik ", attributes: boldAttributes)
        businessLicanse.append(createdBy)
        businessLicanse.append(creator6)
        businessLicanse.append(boldFreepikString)
        
        let saleWomanFigureLicance = NSMutableAttributedString(string: "Surfboard", attributes: underlineAttributes)
        let creator7 = NSAttributedString(string: "freepik ", attributes: boldAttributes)
        saleWomanFigureLicance.append(createdBy)
        saleWomanFigureLicance.append(creator7)
        saleWomanFigureLicance.append(boldFreepikString)
        
        licanses.append(contentsOf: [
            LicansesModel(text: techLicanse, url: "https://www.freepik.com/vectors/technology"),
            LicansesModel(text: backgroundLicanse, url: "https://www.freepik.com/vectors/background"),
            LicansesModel(text: clockLicanse, url: "https://www.freepik.com/vectors/clock"),
            LicansesModel(text: schoolLicanse, url: "https://www.freepik.com/vectors/school"),
            LicansesModel(text: crowdLicanse, url: "https://www.rawpixel.com"),
            LicansesModel(text: businessLicanse, url: "https://www.freepik.com/vectors/business"),
            LicansesModel(text: saleWomanFigureLicance, url: "https://www.freepik.com/vectors/surfboard")
        ])
    }
    
    var body: some View {
        return
            
            ScrollView {
                VStack{
                    Text("Below are the copyrights and licanses used in HomeTwin:")
                        .font(.system(size: 16))
                        .lineSpacing(5)
                        .padding(5)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    ForEach(licanses, id: \.id) { data in
                        HStack {
                            LicansesTextView(licanse: data).padding([.top, .bottom], 5)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
            .navigationBarTitle(Text("Copyright and Licenses"), displayMode: .inline)
            .navigationViewStyle(StackNavigationViewStyle())
            
            
    }
}

struct LicansesTextView: View {
    
    var licanse: LicansesModel
    
    var body: some View {
        AttributedLabelView(text: licanse.text, textAlignment: NSTextAlignment.left)
            .font(.system(size: 16))
            .padding(5)
            .onTapGesture() {
                guard let url = URL(string: licanse.url) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
    }
}

struct LicansesModel {
    let id = UUID()
    let text: NSMutableAttributedString
    let url: String
}


struct AttributedLabelView: UIViewRepresentable {
    var text: NSMutableAttributedString
    var textAlignment : NSTextAlignment = .center
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = textAlignment
        label.attributedText = text
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = text
       // uiView.textColor = UIColor(named: "appBlack")
    }
}
