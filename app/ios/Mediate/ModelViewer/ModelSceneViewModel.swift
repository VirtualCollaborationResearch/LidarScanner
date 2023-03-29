//
//  ModelSceneViewModel.swift
//  LidarScanner
//
//  Created by Oğuz Öztürk on 28.03.2023.
//

import Foundation
import Combine
import ARKit

class ModelSceneViewModel: NSObject, ObservableObject {
    var scan:Scan
    @Published var measures = [MeasureNode]()

    var cleanMeasure = PassthroughSubject<String,Never>()

    init(scan:Scan) {
        self.scan = scan
        super.init()

    }
}
