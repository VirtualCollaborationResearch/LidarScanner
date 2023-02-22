//
//  Destination.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 5.10.2022.
//

import Foundation

enum Destination:Hashable {
    case scanListView
    case menuView
    case scanView
    case modelViewer(Scan)

}
