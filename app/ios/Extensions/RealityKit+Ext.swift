//
//  RealityKit+Ext.swift
//  CommonKit
//
//  Created by Oğuz Öztürk on 16.09.2022.
//  Copyright © 2022 com.mediate. All rights reserved.
//
import ARKit
import RealityKit

extension simd_float4x4: Codable, Hashable {
    var position: SIMD3<Float> {
        return SIMD3<Float>(columns.3.x, columns.3.y, columns.3.z)
    }
    
    func toSCNVector3() -> SCNVector3 {
        let position = columns.3
        return SCNVector3(position.x, position.y, position.z)
    }
    
    var xAxis: simd_float3 {
        return simd_float3(self.columns.0.x, self.columns.0.y, self.columns.0.z)
    }
    var yAxis: simd_float3 {
        return simd_float3(self.columns.1.x, self.columns.1.y, self.columns.1.z)
    }
    var zAxis: simd_float3 {
        return simd_float3(self.columns.2.x, self.columns.2.y, self.columns.2.z)
    }
    var translation: simd_float3 {
        return simd_float3(self.columns.3.x, self.columns.3.y, self.columns.3.z)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        try self.init(container.decode([SIMD4<Float>].self))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode([columns.0,columns.1, columns.2, columns.3])
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.determinant)
     }
}


public extension SIMD4 {
    
    var xyz: SIMD3<Scalar> {
        return self[SIMD3(0, 1, 2)]
    }
    
}

public extension Transform {
    static func * (left: Transform, right: Transform) -> Transform {
        return Transform(matrix: simd_mul(left.matrix, right.matrix))
    }
}

public extension ARMeshGeometry {
    func vertex(at index: UInt32) -> (Float, Float, Float) {
        assert(vertices.format == MTLVertexFormat.float3, "Expected three floats (twelve bytes) per vertex.")
        let vertexPointer = vertices.buffer.contents().advanced(by: vertices.offset + (vertices.stride * Int(index)))
        let vertex = vertexPointer.assumingMemoryBound(to: (Float, Float, Float).self).pointee
        return vertex
    }
}

public extension SCNVector3 {
  func distanceTravelled(xDist:Float, yDist:Float, zDist:Float) -> Float{
    return sqrt((xDist*xDist)+(yDist*yDist)+(zDist*zDist))
  }
  func distanceTo(secondVector: SCNVector3) -> Float {
    let xDist = x - secondVector.x
    let yDist = y - secondVector.y
    let zDist = z - secondVector.z
    return distanceTravelled(xDist: xDist, yDist: yDist, zDist: zDist)
  }
}
extension SCNGeometry {
  class func cylinderLine(from: SCNVector3, to: SCNVector3, segments: Int) -> SCNNode {
    let x1 = from.x
    let x2 = to.x
    let y1 = from.y
    let y2 = to.y
    let z1 = from.z
    let z2 = to.z
    let distance = sqrtf((x2 - x1) * (x2 - x1) +
               (y2 - y1) * (y2 - y1) +
               (z2 - z1) * (z2 - z1))
     
    let cylinder = SCNCylinder(radius: 0.005,
                  height: CGFloat(distance))
    cylinder.radialSegmentCount = segments
    cylinder.firstMaterial?.diffuse.contents = UIColor.yellow
    let lineNode = SCNNode(geometry: cylinder)
    lineNode.position = SCNVector3(((from.x + to.x)/2),
                    ((from.y + to.y)/2),
                    ((from.z + to.z)/2))
    lineNode.eulerAngles = SCNVector3(Float.pi/2,
                     acos((to.z - from.z)/distance),
                     atan2(to.y - from.y, to.x - from.x))
    return lineNode
  }
}
