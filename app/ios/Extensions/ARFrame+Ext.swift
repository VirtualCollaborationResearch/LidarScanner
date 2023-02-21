//
//  ARFrame+Ext.swift
//  HomeTwin-iOS
//
//  Created by Oğuz Öztürk on 20.12.2022.
//

import ARKit
import MetalKit

extension ARFrame.WorldMappingStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notAvailable:
            return "Not Available"
        case .limited:
            return "Limited"
        case .extending:
            return "Extending"
        case .mapped:
            return "Mapped"
        @unknown default:
            return "Unknown"
        }
    }
    
    public var text: String {
        switch self {
        case .notAvailable:
            return "World map isn't available\nContinue scaninng"
        case .limited:
            return "Mapping is limited\nContinue scaninng"
        case .extending:
            return "Map is extending\nContinue scaninng"
        case .mapped:
            return "Map can be saved"
        @unknown default:
            return "Unknown"
        }
    }
}

extension ARFrame {
    func create3DModel(completion:@escaping (URL?)->Void) {
        // Fetch the default MTLDevice to initialize a MetalKit buffer allocator with
        guard let device = MTLCreateSystemDefaultDevice() else {
            completion(nil)
            return
        }
        
        // Using the Model I/O framework to export the scan, so we're initialising an MDLAsset object,
        // which we can export to a file later, with a buffer allocator
        let allocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(bufferAllocator: allocator)
        
        // Fetch all ARMeshAncors
        let meshAnchors = anchors.compactMap({ $0 as? ARMeshAnchor })
        
        // Convert the geometry of each ARMeshAnchor into a MDLMesh and add it to the MDLAsset
        for meshAncor in meshAnchors {
            
            // Some short handles, otherwise stuff will get pretty long in a few lines
            let geometry = meshAncor.geometry
            let vertices = geometry.vertices
            let faces = geometry.faces
            let verticesPointer = vertices.buffer.contents()
            let facesPointer = faces.buffer.contents()
            
            // Converting each vertex of the geometry from the local space of their ARMeshAnchor to world space
            for vertexIndex in 0..<vertices.count {
                
                // Extracting the current vertex with an extension method provided by Apple in Extensions.swift
                let vertex = geometry.vertex(at: UInt32(vertexIndex))
                
                // Building a transform matrix with only the vertex position
                // and apply the mesh anchors transform to convert into world space
                var vertexLocalTransform = matrix_identity_float4x4
                vertexLocalTransform.columns.3 = SIMD4<Float>(x: vertex.0, y: vertex.1, z: vertex.2, w: 1)
                let vertexWorldPosition = (meshAncor.transform * vertexLocalTransform).position
                
                // Writing the world space vertex back into it's position in the vertex buffer
                let vertexOffset = vertices.offset + vertices.stride * vertexIndex
                let componentStride = vertices.stride / 3
                verticesPointer.storeBytes(of: vertexWorldPosition.x, toByteOffset: vertexOffset, as: Float.self)
                verticesPointer.storeBytes(of: vertexWorldPosition.y, toByteOffset: vertexOffset + componentStride, as: Float.self)
                verticesPointer.storeBytes(of: vertexWorldPosition.z, toByteOffset: vertexOffset + (2 * componentStride), as: Float.self)
            }
            
            // Initializing MDLMeshBuffers with the content of the vertex and face MTLBuffers
            let byteCountVertices = vertices.count * vertices.stride
            let byteCountFaces = faces.count * faces.indexCountPerPrimitive * faces.bytesPerIndex
            let vertexBuffer = allocator.newBuffer(with: Data(bytesNoCopy: verticesPointer, count: byteCountVertices, deallocator: .none), type: .vertex)
            let indexBuffer = allocator.newBuffer(with: Data(bytesNoCopy: facesPointer, count: byteCountFaces, deallocator: .none), type: .index)
            
            // Creating a MDLSubMesh with the index buffer and a generic material
            let indexCount = faces.count * faces.indexCountPerPrimitive
            let material = MDLMaterial(name: "mat1", scatteringFunction: MDLPhysicallyPlausibleScatteringFunction())
            let submesh = MDLSubmesh(indexBuffer: indexBuffer, indexCount: indexCount, indexType: .uInt32, geometryType: .triangles, material: material)
            
            // Creating a MDLVertexDescriptor to describe the memory layout of the mesh
            let vertexFormat = MTKModelIOVertexFormatFromMetal(vertices.format)
            let vertexDescriptor = MDLVertexDescriptor()
            vertexDescriptor.attributes[0] = MDLVertexAttribute(name: MDLVertexAttributePosition, format: vertexFormat, offset: 0, bufferIndex: 0)
            vertexDescriptor.layouts[0] = MDLVertexBufferLayout(stride: meshAncor.geometry.vertices.stride)
            
            // Finally creating the MDLMesh and adding it to the MDLAsset
            let mesh = MDLMesh(vertexBuffer: vertexBuffer, vertexCount: meshAncor.geometry.vertices.count, descriptor: vertexDescriptor, submeshes: [submesh])
            asset.add(mesh)
        }
        
        // Setting the path to export the OBJ file to
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let urlOBJ = documentsPath.appendingPathComponent("scan.usdc")
        
        // Exporting the OBJ file
        if MDLAsset.canExportFileExtension("usdc") {
            do {
                try asset.export(to: urlOBJ)
                completion(urlOBJ)
//                MeshScannerPublisher.shared.exportResult.send(urlOBJ)
//                    // Sharing the OBJ file
//                    let activityController = UIActivityViewController(activityItems: [urlOBJ], applicationActivities: nil)
//                    //activityController.popoverPresentationController?.sourceView = btn
//                    UIApplication.shared.currentWindow?.rootViewController?.present(activityController, animated: true, completion: nil)
                
            } catch let error {
                print(error)
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
}
