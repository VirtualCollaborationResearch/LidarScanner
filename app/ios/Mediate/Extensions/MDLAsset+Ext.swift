//
//  MDLAsset+Ext.swift
//  3DScanner
//
//  Created by Oğuz Öztürk on 24.02.2023.
//

import SceneKit.ModelIO

extension MDLAsset {
    func convertToUsdz(objUrl: URL,completion: ((URL?) -> Void)?) {
        var usdzUrl = objUrl
        usdzUrl.deletePathExtension()
        usdzUrl.appendPathExtension("usdz")
        
        if !FileManager.default.fileExists(atPath: usdzUrl.path) {
            loadTextures()
            let scene = SCNScene(mdlAsset: self)
            scene.rootNode.geometry?.firstMaterial?.lightingModel = .physicallyBased
            scene.write(to: usdzUrl, delegate: nil,progressHandler: { progres, err, _ in
                if err == nil, progres == 1 {
                    completion?(usdzUrl)
                } else {
                    completion?(nil)
                }
            })
        } else {
            completion?(usdzUrl)
        }
    }
}
