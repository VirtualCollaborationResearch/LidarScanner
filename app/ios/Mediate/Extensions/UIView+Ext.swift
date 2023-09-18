//
//  UIView+Ext.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 9.02.2023.
//

import UIKit

extension UIView {
    var snapshot: UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}
