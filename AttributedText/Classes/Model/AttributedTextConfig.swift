//
//  AttributedTextConfig.swift
//  AttributedText
//
//  Created by wave on 2019/6/21.
//

import Foundation

public struct AttributedTextConfig {
    
    /// eg: "#\\u200b.*?\\u200b"
    public var pattern: String
    
    /// eg: "|"
    public var separatorKey: String
    
    public init(pattern: String, separatorKey: String) {
        self.pattern = pattern
        self.separatorKey = separatorKey
    }
}
