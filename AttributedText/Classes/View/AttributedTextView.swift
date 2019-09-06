//
//  AttributedTextView.swift
//  AttributedText
//
//  Created by wave on 2019/6/20.
//

import UIKit
import SwifterSwift

public class AttributedTextView: UITextView {
    
    deinit {
        removeObserver(self, forKeyPath: "selectedTextRange")
        removeObserver(self, forKeyPath: "text")
        removeObserver(self, forKeyPath: "attributedText")
    }

    /// text change
    public var textChanged: ((String)->())?
    
    /// 模型转换, 必须要实现.
    public var modelMapper: ((String)->(TextModel?))?
    
    /// 最终要输出的文本
    public var outputs: TextViewOutputModel {
        
        let hashtagTextAttr = NSMutableAttributedString(attributedString: attributedText)
        
        attributedText.enumerateAttribute(NSAttributedString.Key(rawValue: kAttributedTextViewSpecialTextKeyAttributeName), in: NSRange(location: 0, length: attributedText.length), options: NSAttributedString.EnumerationOptions.reverse) { (attr, range, _) in
            
            if let insertModel = attr as? TextViewInserAttributeModel {
                
                let value = insertModel.textModel.content
                hashtagTextAttr.replaceCharacters(in: range, with: value)
            }
        }
        return TextViewOutputModel(hashtagText: hashtagTextAttr.string, text: attributedText.string)
    }
    
    /// placeholder
    public var placeholder: String? {
        didSet {
            self.placeholderView.label.text = placeholder
        }
    }
    
    /// 默认文本样式
    public var defaultAttributes: [NSAttributedString.Key : Any] = [:] {
        didSet{
            typingAttributes = defaultAttributes
        }
    }
    
    /// placeholderView
    private let placeholderView = AttributedTextPlaceholderView()

    /// insert attributed key
    private let kAttributedTextViewSpecialTextKeyAttributeName = "kAttributedTextViewSpecialTextKeyAttributeName"
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        configureTextView()
        configurePlaceholderView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        configureTextView()
        configurePlaceholderView()
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "selectedTextRange" {
            
            guard
                let newContentStr = change?[NSKeyValueChangeKey.newKey] as? UITextRange,
                let oldContentStr = change?[NSKeyValueChangeKey.oldKey] as? UITextRange
                else { return }
            
            /// 光标当前位置
            let newRange = selectedRange(selectedTextRange: newContentStr)
            let oldRange = selectedRange(selectedTextRange: oldContentStr)
            if newRange.location != oldRange.location {
                
                attributedText.enumerateAttribute(NSAttributedString.Key(rawValue: kAttributedTextViewSpecialTextKeyAttributeName), in: NSMakeRange(0, attributedText.length), options: NSAttributedString.EnumerationOptions.reverse) { (attrs, range, stop) in
                    
                    if let _ = attrs as? TextViewInserAttributeModel {
                        
                        if newRange.location > range.location && newRange.location < range.location+range.length {
                            /// cursor left value
                            let leftValue = newRange.location - range.location
                            /// cursor right value
                            let rightValue = range.location + range.length - newRange.location
                            if (leftValue >= rightValue) {
                                self.selectedRange = NSMakeRange(self.selectedRange.location-leftValue, 0);
                            }else{
                                self.selectedRange = NSMakeRange(self.selectedRange.location+rightValue, 0);
                            }
                        }
                    }
                }
            }
        } else if keyPath == "text" || keyPath == "attributedText" {
            placeholderView.isHidden = text == "" ? false : true
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

public extension AttributedTextView {
    
    ///  add model
    func insertSpecialText(model: TextModel, isDeleteLastString: Bool) {
        
        var rg = selectedRange
        
        let currentTextAttText = NSMutableAttributedString(attributedString: attributedText)
        
        if isDeleteLastString && selectedRange.location != 0 {
            currentTextAttText.deleteCharacters(in: NSRange(location: selectedRange.location - 1, length: 1))
            rg = NSMakeRange(selectedRange.location - 1, 0)
        }
        
        let modelAttr = createAtt(model: model)
        currentTextAttText.insert(modelAttr, at: rg.location)
        
        attributedText = currentTextAttText
        
        typingAttributes = defaultAttributes
        
        selectedRange = NSMakeRange(rg.location + modelAttr.length, 0)
        scrollRangeToVisible(NSRange(location: rg.location, length: 0))
    }
    
    /// add attr
    func set(text: String) {
        
        let resultAttr = NSMutableAttributedString(string: text, attributes: defaultAttributes)
        
        let matches = text.matchingStrings(regex: "#\\u200b.*?\\u200b")

        for content in matches {
            
            let range = (resultAttr.string as NSString).range(of: content)
            if let model = modelMapper?(content) {
                let attr = createAtt(model: model)
                resultAttr.replaceCharacters(in: range, with: attr)
            }
        }
        
        attributedText = resultAttr

        typingAttributes = defaultAttributes

        selectedRange = NSRange(location: attributedText.length, length: 0)
        scrollRangeToVisible(NSRange(location: attributedText.length, length: 0))
    }
}

extension AttributedTextView: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        textChanged?(text)
        
        /// delete
        if text == "" {
            
            var deletedSpecial = false
            let oldRange = selectedRange
            attributedText.enumerateAttribute(NSAttributedString.Key(rawValue: kAttributedTextViewSpecialTextKeyAttributeName), in: NSMakeRange(0, attributedText.length), options: NSAttributedString.EnumerationOptions.reverse) { [weak self] (attr, range, stop) in
                
                guard let `self` = self else { return }
                
                let deleteRange = NSMakeRange(self.selectedRange.location - 1, 0)
                
                /* range 有 bug, 如果两个标签放在一块儿, 正常位置是(0,8)(9,18), 那么在这个循环里边, range 会返回 (0,18),  暂时没解决, 用个模型包起来长度来解决. */
                if let insertModel = attr as? TextViewInserAttributeModel {
                    let textModel = insertModel.textModel
                    if deleteRange.location > range.location && deleteRange.location < range.location + range.length {
                        /// 默认整段删除
                        let textAttStr = NSMutableAttributedString(attributedString: self.attributedText)
                        if textModel.isDeleteAll {
                            let range = NSRange(location: self.selectedRange.location - insertModel.length, length: insertModel.length)
                            textAttStr.deleteCharacters(in: range)
                            self.attributedText = textAttStr
                            self.selectedRange = NSMakeRange(oldRange.location - range.length, 0)
                        } else {
                            let range = NSRange(location: self.selectedRange.location - insertModel.length, length: insertModel.length)
                            textAttStr.removeAttribute(NSAttributedString.Key(rawValue: kAttributedTextViewSpecialTextKeyAttributeName), range: range)
                            textAttStr.deleteCharacters(in: NSRange(location: self.selectedRange.location - 1, length: 1))
                            self.attributedText = textAttStr
                            self.selectedRange = NSMakeRange(oldRange.location - 1, 0)
                        }
                        deletedSpecial = true
                        stop.pointee = true
                    }
                }
            }
            
            typingAttributes = defaultAttributes
            return !deletedSpecial
        }
        
        typingAttributes = defaultAttributes

        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        
        placeholderView.isHidden = textView.text == "" ? false : true

        typingAttributes = defaultAttributes
    }
}

private extension AttributedTextView {
    
    func createAtt(model: TextModel) -> NSMutableAttributedString {
        
        let mutableAttrString = NSMutableAttributedString(string: "")
        
        /// 添加文本
        let text = "\(model.symbol ?? "")\(model.text)"
        let textMutableAttrString = NSMutableAttributedString(string: text)
        textMutableAttrString.addAttributes(model.attributes, range: NSRange(location: 0, length: textMutableAttrString.length))
        mutableAttrString.insert(textMutableAttrString, at: mutableAttrString.length)
        
        /// 添加图片
        if
            let image = model.image,
            let location = model.imageLocation {
            let attach = NSTextAttachment()
            attach.image = image
            attach.bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            let attachString = NSAttributedString(attachment: attach)
            switch location {
            case .left:   mutableAttrString.insert(attachString, at: 0)
            case .right:  mutableAttrString.insert(attachString, at: mutableAttrString.length)
            }
        }
        
        /// 添加空格
        let spaceAttributedString = NSAttributedString(string: " ")
        mutableAttrString.insert(spaceAttributedString, at: mutableAttrString.length)
        
        /// 添加标识符
        let insertModel = TextViewInserAttributeModel.init(length: mutableAttrString.length, textModel: model)
        mutableAttrString.addAttribute(NSAttributedString.Key(rawValue: kAttributedTextViewSpecialTextKeyAttributeName), value: insertModel, range: NSRange(location: 0, length: mutableAttrString.length))
        
        return mutableAttrString
    }
    
    func selectedRange(selectedTextRange: UITextRange) -> NSRange {
        
        let location = offset(from: beginningOfDocument, to: selectedTextRange.start)
        let length = offset(from: selectedTextRange.start, to: selectedTextRange.end)
        return NSRange(location: location, length: length)
    }
}

private extension AttributedTextView {
    
    @objc func clickPlaceholderView() {
        becomeFirstResponder()
    }
}

private extension AttributedTextView {
    
    func configureTextView() {

        defaultAttributes = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(red: 74, green: 74, blue: 74) ?? .black
        ]

        delegate = self
        
        addObserver(self, forKeyPath: "selectedTextRange", options: [NSKeyValueObservingOptions.old, NSKeyValueObservingOptions.new], context: nil)
        addObserver(self, forKeyPath: "text", options: [], context: nil)
        addObserver(self, forKeyPath: "attributedText", options: [], context: nil)
    }

    func configurePlaceholderView() {
        
        addSubview(placeholderView)
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        placeholderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        placeholderView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        placeholderView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        placeholderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickPlaceholderView)))
    }
}
