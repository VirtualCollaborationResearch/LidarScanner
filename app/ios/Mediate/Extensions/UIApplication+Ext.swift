//
//  UIApplication+Ext.swift
//  CommonKit
//
//  Created by Oğuz Öztürk on 16.09.2022.
//  Copyright © 2022 com.mediate. All rights reserved.
//

import UIKit

public extension UIApplication {
    
    var currentWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
        // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
        // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
        // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
        // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
    var orientation:UIInterfaceOrientation? {
        currentWindow?.windowScene?.interfaceOrientation
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
