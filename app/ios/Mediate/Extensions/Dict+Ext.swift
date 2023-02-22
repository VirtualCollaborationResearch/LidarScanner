//
//  Dict+Ext.swift
//  HomeTwin-iOS
//
//  Created by Hatice Nur OKUR on 25.11.2022.
//

import Foundation

extension Dictionary {
    public static func +=(lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach({ lhs[$0] = $1})
        
    }
}
