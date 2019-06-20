//
//  TextViewOutputModel.swift
//  AttributedText
//
//  Created by wave on 2019/6/20.
//

import Foundation

public struct TextViewOutputModel {
    
    public let hashtagText: String
    
    public let text: String
    
    init(hashtagText: String, text: String) {
        self.hashtagText = hashtagText
        self.text = text
    }
}
