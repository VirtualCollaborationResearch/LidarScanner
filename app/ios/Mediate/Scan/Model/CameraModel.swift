import Foundation
import ARKit

struct CameraModel: Codable {
    let fx, fy, cx, cy: Float
    let t_00, t_01, t_02, t_03: Float
    let t_10, t_11, t_12, t_13: Float
    let t_20, t_21, t_22, t_23: Float
    let timestamp: Double
    let width, height: Int
    
    init(frame:ARFrame) {
        let intrinsics = frame.camera.intrinsics
        fx = intrinsics[0,0]
        fy = intrinsics[1,1]
        cx = intrinsics[2,0]
        cy = intrinsics[2,1]
        
        let transform = frame.camera.transform
        
        t_00 = transform[0,0]
        t_01 = transform[1,0]
        t_02 = transform[2,0]
        t_03 = transform[3,0]
        
        t_10 = transform[0,1]
        t_11 = transform[1,1]
        t_12 = transform[2,1]
        t_13 = transform[3,1]
        
        t_20 = transform[0,2]
        t_21 = transform[1,2]
        t_22 = transform[2,2]
        t_23 = transform[3,2]
        
        timestamp = Double(frame.timestamp)
        width = Int(frame.camera.imageResolution.width)
        height = Int(frame.camera.imageResolution.height)
    }
    
    func writeToDisk(name:String) {
        if let folder = FileManager.default.createFolder(name: "RT-Images"),
        let data = try? JSONEncoder().encode(self) {
            try? data.write(to: folder.appendingPathComponent(name+".json"))
        }
    }
}
