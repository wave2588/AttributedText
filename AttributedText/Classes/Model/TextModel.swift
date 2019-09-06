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
    
    /// 当前文本的 id
    public var id: String
    
    /// 文本是否要匹配一个特殊字符, eg: @
    public var symbol: String?
    
    /// 插入的文本
    public var text: String
    
    /// 图片
    public var image: UIImage?
    
    /// 图片的位置, 文本的最左边 或 最右边
    public var imageLocation: TextModel.ImageLocation?
    
    /// 插入的文本的类型, 只是在生成最终格式的时候需要
    public var type: Int
    
    /// 插入文本的样式
    public var attributes: [NSAttributedString.Key : Any]
    
    /// 是否整段特殊删除
    public var isDeleteAll: Bool = true

    /// 最终生成的文本 ("#\u200b|id|type|text\u200b")
    public var content: String
    
    var unicodeText: String

    public init(id: String, symbol: String?, text: String, image: UIImage?, imageLocation: TextModel.ImageLocation?, type: Int, attributes: [NSAttributedString.Key : Any]) {

        self.id = id
        self.symbol = symbol
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
