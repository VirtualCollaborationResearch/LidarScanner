//
//  FirabaseUploader.swift
//  3DScanner
//
//  Created by Oğuz Öztürk on 27.02.2023.
//

import FirebaseStorage
import Combine
import Foundation

class FirebaseUploader:NSObject {
    
    static let shared = FirebaseUploader()
    let storage = Storage.storage()
    let percentage = PassthroughSubject<(Double,UUID),Never>()
    
    func upload(zipUrl:URL,scanId:UUID) {
        
        let scansRef = storage.reference().child("scans/zippedObj/\(zipUrl.lastPathComponent)")
        
        print(zipUrl)

        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = scansRef.putFile(from: zipUrl)
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            print("Upload resumed, also fires when the upload starts")
        }

        uploadTask.observe(.pause) { snapshot in
            print("Upload paused")
        }

        uploadTask.observe(.progress) { [unowned self] snapshot in
          // Upload reported progress
          let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
            self.percentage.send((percentComplete,scanId))
        }

        uploadTask.observe(.success) { snapshot in
            print("Upload completed successfully")
        }

        uploadTask.observe(.failure) { snapshot in
          if let error = snapshot.error as? NSError {
            switch (StorageErrorCode(rawValue: error.code)!) {
            case .objectNotFound:
                print("File doesn't exist")
              break
            case .unauthorized:
                print("User doesn't have permission to access file")
              break
            case .cancelled:
                print("User canceled the upload")
              break

            /* ... */

            case .unknown:
                print("Unknown error occurred, inspect the server response")
              break
            default:
                print(" A separate error occurred. This is a good place to retry the upload.")
              break
            }
          }
        }
    }
}
