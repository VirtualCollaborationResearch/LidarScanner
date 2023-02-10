//
//  AppDelegate.swift
//  GLKittutorial
//
//  Created by Mathieu Labbe on 2020-12-28.
//

import UIKit
import ARKit
import VideoToolbox

func setDefaultsFromSettingsBundle() {
    
    let plistFiles = ["Root", "Mapping", "Assembling"]
    
    for plistName in plistFiles {
        //Read PreferenceSpecifiers from Root.plist in Settings.Bundle
        if let settingsURL = Bundle.main.url(forResource: plistName, withExtension: "plist", subdirectory: "Settings.bundle"),
            let settingsPlist = NSDictionary(contentsOf: settingsURL),
            let preferences = settingsPlist["PreferenceSpecifiers"] as? [NSDictionary] {

            for prefSpecification in preferences {

                if let key = prefSpecification["Key"] as? String, let value = prefSpecification["DefaultValue"] {

                    //If key doesn't exists in userDefaults then register it, else keep original value
                    if UserDefaults.standard.value(forKey: key) == nil {

                        UserDefaults.standard.set(value, forKey: key)
                        NSLog("registerDefaultsFromSettingsBundle: Set following to UserDefaults - (key: \(key), value: \(value), type: \(type(of: value)))")
                    }
                }
            }
        } else {
            NSLog("registerDefaultsFromSettingsBundle: Could not find Settings.bundle")
        }
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Always set Version to default
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "Version")
        
        setDefaultsFromSettingsBundle()
        
        // Override point for customization after application launch.
        if !ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            // Ensure that the device supports scene depth and present
            //  an error-message view controller, if not.
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "unsupportedDeviceMessage")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension FileManager {
    func createFolder(with name:String) -> URL {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryPath = documentDirectory.appendingPathComponent(name)
        
        if !FileManager.default.fileExists(atPath: directoryPath.relativePath) {
            do {
                try FileManager.default.createDirectory(atPath: directoryPath.relativePath,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return directoryPath
    }
}

extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer?) {
        guard let pixelBuffer = pixelBuffer else { return nil }
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        guard let cgImage = cgImage else {
            return nil
        }
        
        self.init(cgImage: cgImage)
    }
    
    func save(name:String) -> URL? {
        let folderURL = FileManager.default.createFolder(with: "RT-Images")
        let imageUrl = folderURL.appendingPathComponent(name+".jpeg")
        let imageData = self.jpegData(compressionQuality: 0.8)
        try? imageData?.write(to: imageUrl)
        return imageUrl
    }
}

extension CGImage {
    public func convert() throws -> CVPixelBuffer {
                
        let options : [ String : Bool ] = [
            kCVPixelBufferCGImageCompatibilityKey         as String : false,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String : false
        ]
        
        var bufferRef : CVPixelBuffer? = nil
        
        let status : CVReturn = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32BGRA, //kCVPixelFormatType_32RGBA cases error
            options as CFDictionary,
            &bufferRef
        )
        
        guard status == kCVReturnSuccess else { fatalError( status.description ) }
        guard let buffer : CVPixelBuffer = bufferRef else { fatalError( "No buffer returned" ) }
        
        let lockFlags = CVPixelBufferLockFlags(rawValue: CVOptionFlags(0))
        
        CVPixelBufferLockBaseAddress( buffer, lockFlags )
        
        guard let pixelData : UnsafeMutableRawPointer = CVPixelBufferGetBaseAddress( buffer ) else { fatalError("Can't get buffer base address") }
        
        let rgbColorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let context : CGContext = CGContext(
            data             : pixelData,
            width            : width,
            height           : height,
            bitsPerComponent : bitsPerComponent,
            bytesPerRow      : bytesPerRow,
            space            : rgbColorSpace,
            bitmapInfo       : CGImageAlphaInfo.noneSkipLast.rawValue
        )
        else { fatalError( "Can't create CGContext" ) }
        
        let rect : CGRect = CGRect(x: 0, y: 0, width: CGFloat( width ), height: CGFloat( height ) )
        
        context.draw( self, in: rect)
        
        CVPixelBufferUnlockBaseAddress( buffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)) )
        
        return buffer
    }
}
