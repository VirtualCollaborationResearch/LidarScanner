//
//  Defaults.swift
//  UtilityKit
//
//  Created by Oğuz Öztürk on 14.09.2022.
//
import Foundation

@propertyWrapper
public struct Defaults<Value:Codable> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }

   public var wrappedValue: Value {
        get {
            guard let data = container.object(forKey: key) as? Data else {
                    return defaultValue
                }
            
            let value = try? JSONDecoder().decode(Value.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            
            container.set(data, forKey: key)
        }
    }
}

extension UserDefaults {
    @Defaults(key: "scans", defaultValue: [])
    static var scans: [Scan]
}
