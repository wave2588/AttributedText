//
//  TextViewModel.swift
//  AttributedText
//
//  Created by wave on 2019/6/20.
//

import Foundation

let separatorKey = "|"
let nullWideCharacter = "\\u200b"

/// separatorKey 分隔符
/// nullWideCharacter 零宽字符
/// unicodeText 格式 "#\u200b|id|type|text\u200b"

public struct TextViewModel {

    var unicodeText: String
    
    var id: String
    
    var text: String
    
    var symbolStr: String?
    
    var image: UIImage?
    
    var type: Int
    
    public init(id: String, text: String, symbolStr: String?, image: UIImage?, type: Int) {
        
        self.id = id
        self.text = text
        self.symbolStr = symbolStr
        self.image = image
        self.type = type
        
        self.unicodeText = "#\(nullWideCharacter)\(separatorKey)\(id)\(separatorKey)\(type)\(separatorKey)\(text.utf8ConvertUnicodeStr)\(nullWideCharacter)"
    }
}
