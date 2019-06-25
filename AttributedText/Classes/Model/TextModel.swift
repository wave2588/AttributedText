//
//  TextModel.swift
//  AttributedText
//
//  Created by wave on 2019/6/20.
//

import Foundation

/// separatorKey 分隔符
/// nullWideCharacter 零宽字符
/// unicodeText 格式 "#\u200b|id|type|text\u200b"

public struct TextModel {
    
    public var id: String
    
    public var text: String
    
    public var symbolStr: String?
    
    public var image: UIImage?
    
    public var type: Int
    
    public var content: String
    
    var unicodeText: String

    public init(id: String, text: String, symbolStr: String?, image: UIImage?, type: Int) {

        self.id = id
        self.text = text
        self.symbolStr = symbolStr
        self.image = image
        self.type = type

        let separatorKey = "|"
        let nullWideCharacter = "\\u200b"
        self.unicodeText = "#\(nullWideCharacter)\(separatorKey)\(id)\(separatorKey)\(type)\(separatorKey)\(text.utf8ConvertUnicodeStr)\(nullWideCharacter)"
        
        self.content = self.unicodeText.unicodeConvertUtf8
    }
}
