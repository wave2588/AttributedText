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
    
    public enum ImageLocation {
        case left
        case right
    }
    
    public var id: String
    
    public var text: String
    
    public var image: UIImage?
    
    public var imageLocation: TextModel.ImageLocation?
    
    public var type: Int
    
    public var content: String
    
    public var attributes: [NSAttributedString.Key : Any]
    
    var unicodeText: String

    public init(id: String, text: String, image: UIImage?, imageLocation: TextModel.ImageLocation?, type: Int, attributes: [NSAttributedString.Key : Any]) {

        self.id = id
        self.text = text
        self.image = image
        self.imageLocation = imageLocation
        self.type = type

        let separatorKey = "|"
        let nullWideCharacter = "\\u200b"
        self.unicodeText = "#\(nullWideCharacter)\(separatorKey)\(id)\(separatorKey)\(type)\(separatorKey)\(text.utf8ConvertUnicodeStr)\(nullWideCharacter)"
        
        self.content = self.unicodeText.unicodeConvertUtf8
        self.attributes = attributes
    }
}
