//
//  ContactUsView.swift
//  Scanner-iOS
//
//  Created by Oğuz Öztürk on 29.12.2022.
//

import SwiftUI
import Combine

struct ContactUsView : View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = ContactUsViewModel()
    let isPad = UIDevice.current.userInterfaceIdiom == .pad

    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill( LinearGradient(gradient: Gradient(colors: [ Color.backgroundDarkGradient, Color.backgroundDarkGradient, Color.backgroundMiddleGradient, Color.listBackground, Color.listBackground]),
                                      startPoint: .top,
                                      endPoint: .bottom))
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geo in
                VStack {
                    
                    Text("Your opinion is very important to us. Please let us know how to make our app better for you by writing your feedback below.")
                        .foregroundColor(.appBlack)
                        .font(.system(size: 15))
                    
                    TextEditor(text: $viewModel.feedback)
                        .background(Color.appWhite)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                                .opacity(0.3)
                            
                        )
                        .padding(5)
                        .accessibility(hint: Text("enter your feedback here."))
                    
                    TextField("E-mail", text: $viewModel.mailAddress)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.appWhite)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                                .opacity(0.3)
                            
                        )
                        .padding(5)
                        .accessibility(hint: Text("enter your contact mail here."))
                    
                    
                    Button {
                        viewModel.addFeedback()
                        
                    } label: {
                        Text("SUBMIT")
                            .font(.system(size:18))
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding(15)
                            .background(Color.green)
                            .cornerRadius(8)
                            .accessibility(addTraits: .isButton)
                            .accessibility(hint: Text("submit"))
                            .padding(5)
                            .padding(.bottom,70)
                    }
                    
                    
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text(viewModel.alertText), dismissButton: .default(Text("OK")){
                        if viewModel.isSubmitSuccessfull {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    })
                }
                .padding([.bottom,.leading,.trailing],UIDevice.current.userInterfaceIdiom == .pad ? 40 : 12)
                .navigationBarTitle("Contact Us")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            UIApplication.shared.endEditing()
                            
                        } label: {
                           Text("Done")
                                .foregroundColor(.appBlack)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    //FirebaseAnalyticsReporter.shared.report(AEMenuViewContactUsTapped())
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("popToRoot"), object: nil)) { value in
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        
    }
}


class ContactUsViewModel: ObservableObject {
    @Published var feedback : String = ""
    @Published var mailAddress : String = "" {
        didSet {
            isValidEmail(mailAddress)
            
        }}
    @Published var didEnterValidEmail = false
    //@Published var databaseManager = DatabaseManager()
    @Published var alertText = ""
    @Published var showAlert: Bool = false
    @Published var isSubmitSuccessfull: Bool = false
    
   // private let reporter: AnalyticsReporter = FirebaseAnalyticsReporter.shared
    
    var cancellable: Cancellable?
    
    func isValidEmail(_ email: String) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        didEnterValidEmail = !email.isEmpty && emailPred.evaluate(with: email)
    }
    
    func addFeedback() {
        
        if feedback.isEmpty {
            self.showAlert = true
            self.alertText = "Text field can not be empty!"
            self.isSubmitSuccessfull = false
            
        }
//        else {
//            let feedbackWithMail = feedback + "\n\n" + (didEnterValidEmail ? mailAddress : "")
//            print("feedback: ", feedbackWithMail)
//            cancellable = databaseManager.addFeedback(feedbackWithMail)
//                .receive(on: DispatchQueue.main)
//                .sink(receiveValue: { result in
//
//                    switch result {
//                    case .noUser:
//                        self.showAlert = true
//                        self.alertText = "An error occured. Please try again later!"
//                        self.isSubmitSuccessfull = false
//
//                    case .parameterWritten :
//                        print("")
//
//                    case .dataWritten:
//                        //self.reporter.report(AEContactUsGivenFeedback(feedback: feedbackWithMail))
//                        self.showAlert = true
//                        self.alertText = "Your feedback has been sent successfully."
//                        self.isSubmitSuccessfull = true
//                        self.feedback = ""
//
//                    case .errorOccured(_):
//                        self.showAlert = true
//                        self.alertText = "An error occured. Please try again later!"
//                        self.isSubmitSuccessfull = false
//
//                    case .noInternetConnection:
//                        self.showAlert = true
//                        self.alertText = "There is no internet connection. Please check your status!"
//                        self.isSubmitSuccessfull = false
//                    }
//                })
//        }
    }
}
