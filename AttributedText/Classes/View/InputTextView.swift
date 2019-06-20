//
//  InputTextView.swift
//  AttributedText
//
//  Created by wave on 2019/6/20.
//

import UIKit

public class InputTextView: UITextView {
    
    deinit {
        removeObserver(self, forKeyPath: "selectedTextRange")
        removeObserver(self, forKeyPath: "text")
        removeObserver(self, forKeyPath: "attributedText")
    }

    /// text change
    public var textChanged: ((String)->())?
    
    /// outputs
    public var outputs: TextViewOutputModel {
        
        let hashtagTextAttr = NSMutableAttributedString(attributedString: attributedText)
        
        attributedText.enumerateAttribute(NSAttributedString.Key(rawValue: kInputTextViewSpecialTextKeyAttributeName), in: NSRange(location: 0, length: attributedText.length), options: NSAttributedString.EnumerationOptions.reverse) { (attr, range, _) in
            
            if let model = attr as? TextViewInserAttributeModel {
                
                let value = model.content
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
    
    /// default text style
    public var defaultAttributes: [NSAttributedString.Key : Any] = [:] {
        didSet{
            typingAttributes = defaultAttributes.mapKeysAndValues({ key, value -> (String, Any) in
                return (key.rawValue, value)
            })
        }
    }
    
    /// special text style
    public var linkAttributes: [NSAttributedString.Key : Any] = [:] {
        didSet {
            linkTextAttributes = linkAttributes.mapKeysAndValues({ key, value -> (String, Any) in
                return (key.rawValue, value)
            })
        }
    }
    
    
    /// placeholderView
    private let placeholderView: InputTextViewPlaceholderView = .fromNib()

    /// 标记插入文本的索引值
    private let kInputTextViewSpecialTextKeyAttributeName = "kInputTextViewSpecialTextKeyAttributeName"

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
                
                attributedText.enumerateAttribute(NSAttributedString.Key(rawValue: kInputTextViewSpecialTextKeyAttributeName), in: NSMakeRange(0, attributedText.length), options: NSAttributedString.EnumerationOptions.reverse) { (attrs, range, stop) in
                    
                    if let _ = attrs as? TextViewInserAttributeModel {
                        
                        if newRange.location > range.location && newRange.location < range.location+range.length {
                            //光标距离左边界的值
                            let leftValue = newRange.location - range.location
                            //光标距离右边界的值
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

public extension InputTextView {
    
    ///  add model
    func insertSpecialText(model: TextViewModel, isDeleteLastString: Bool) {
        
        var rg = selectedRange
        
        let currentTextAttText = NSMutableAttributedString(attributedString: attributedText)
        
        if isDeleteLastString && selectedRange.location != 0 {
            currentTextAttText.deleteCharacters(in: NSRange(location: selectedRange.location - 1, length: 1))
            rg = NSMakeRange(selectedRange.location - 1, 0)
        }
        
        let modelAttr = createAtt(model: model)
        currentTextAttText.insert(modelAttr, at: rg.location)
        
        attributedText = currentTextAttText
        
        typingAttributes = defaultAttributes.mapKeysAndValues({ key, value -> (String, Any) in
            return (key.rawValue, value)
        })
        
        selectedRange = NSMakeRange(rg.location + modelAttr.length, 0)
        scrollRangeToVisible(NSRange(location: rg.location, length: 0))
    }
    
    /// add text
    func set(text: String) {
        
        let resultAttr = NSMutableAttributedString(string: text, attributes: defaultAttributes)
        
        let matches = resultAttr.string.matchingStrings(regex: "#\\u200b.*?\\u200b")

        for content in matches {
            
            let range = (resultAttr.string as NSString).range(of: content)
            
            
//            let hashTagModel = TextViewHashTagModel(text: content)
//            if
//                let id = hashTagModel.id,
//                let content = hashTagModel.content,
//                let type = hashTagModel.type {
//
//                let attr = createAtt(model: TextViewModel(id: id, content: content, type: type))
//                resultAttr.replaceCharacters(in: range, with: attr)
//            }
        }

        attributedText = resultAttr
        
        typingAttributes = defaultAttributes.mapKeysAndValues({ key, value -> (String, Any) in
            return (key.rawValue, value)
        })

        selectedRange = NSRange(location: resultAttr.length, length: 0)
        scrollRangeToVisible(NSRange(location: resultAttr.length, length: 0))
    }
}

extension InputTextView: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        textChanged?(text)
        
        /// delete
        if text == "" {
            
            var deletedSpecial = false
            let oldRange = selectedRange
            attributedText.enumerateAttribute(NSAttributedString.Key(rawValue: kInputTextViewSpecialTextKeyAttributeName), in: NSMakeRange(0, attributedText.length), options: NSAttributedString.EnumerationOptions.reverse) { (attr, range, stop) in
                
                let deleteRange = NSMakeRange(self.selectedRange.location - 1, 0)
                
                /* range 有 bug, 如果两个标签放在一块儿, 正常位置是(0,8)(9,18), 那么在这个循环里边, range 会返回 (0,18),  暂时没解决, 用个模型包起来长度来解决. */
                if let model = attr as? TextViewInserAttributeModel {
                    if deleteRange.location > range.location && deleteRange.location < range.location + range.length {
                        let textAttStr = NSMutableAttributedString(attributedString: self.attributedText)
                        let range = NSRange(location: self.selectedRange.location - model.length, length: model.length)
                        textAttStr.deleteCharacters(in: range)
                        self.attributedText = textAttStr
                        self.selectedRange = NSMakeRange(oldRange.location - range.length, 0)
                        deletedSpecial = true
                        stop.pointee = true
                    }
                }
            }
            
            typingAttributes = defaultAttributes.mapKeysAndValues({ key, value -> (String, Any) in
                return (key.rawValue, value)
            })
            return !deletedSpecial
        }
        
        typingAttributes = defaultAttributes.mapKeysAndValues({ key, value -> (String, Any) in
            return (key.rawValue, value)
        })

        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        
        placeholderView.isHidden = textView.text == "" ? false : true

        typingAttributes = defaultAttributes.mapKeysAndValues({ key, value -> (String, Any) in
            return (key.rawValue, value)
        })
    }
}

private extension InputTextView {
    
    func createAtt(model: TextViewModel) -> NSMutableAttributedString {
        
        let mutableAttrString = NSMutableAttributedString(string: "")
        
        /// symbol
        if let symbol = model.symbolStr {
            let symbolMutableAttrString = NSMutableAttributedString(string: symbol)
            symbolMutableAttrString.addAttributes(linkAttributes, range: NSRange(location: 0, length: symbolMutableAttrString.length))
            mutableAttrString.insert(symbolMutableAttrString, at: mutableAttrString.length)
        }
        
        /// image
        if let image = model.image {
            let attach = NSTextAttachment()
            attach.image = image
            attach.bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            let attachString = NSAttributedString(attachment: attach)
            mutableAttrString.insert(attachString, at: mutableAttrString.length)
        }
        
        /// text
        let textMutableAttrString = NSMutableAttributedString(string: model.text)
        textMutableAttrString.addAttributes(linkAttributes, range: NSRange(location: 0, length: textMutableAttrString.length))
        mutableAttrString.insert(textMutableAttrString, at: mutableAttrString.length)
        
        /// space
        let spaceAttributedString = NSAttributedString(string: " ")
//        mutableAttrString.insert(spaceAttributedString, at: 0)
        mutableAttrString.insert(spaceAttributedString, at: mutableAttrString.length)
        
        /// add special key
        var insertModel = TextViewInserAttributeModel()
        insertModel.content = model.unicodeText.unicodeConvertUtf8
        insertModel.length = mutableAttrString.length
        mutableAttrString.addAttribute(NSAttributedString.Key(rawValue: kInputTextViewSpecialTextKeyAttributeName), value: insertModel, range: NSRange(location: 0, length: mutableAttrString.length))
        
        return mutableAttrString
    }
    
    func selectedRange(selectedTextRange: UITextRange) -> NSRange {
        
        let location = offset(from: beginningOfDocument, to: selectedTextRange.start)
        let length = offset(from: selectedTextRange.start, to: selectedTextRange.end)
        return NSRange(location: location, length: length)
    }
}

private extension InputTextView {
    
    @objc func clickPlaceholderView() {
        becomeFirstResponder()
    }
}

private extension InputTextView {
    
    func configureTextView() {

        defaultAttributes = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(red: 74, green: 74, blue: 74) ?? .black
        ]
        
        linkAttributes = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(red: 69, green: 144, blue: 229) ?? .black
        ]

        delegate = self
        
        addObserver(self, forKeyPath: "selectedTextRange", options: [NSKeyValueObservingOptions.old, NSKeyValueObservingOptions.new], context: nil)
        addObserver(self, forKeyPath: "text", options: [], context: nil)
        addObserver(self, forKeyPath: "attributedText", options: [], context: nil)
    }

    func configurePlaceholderView() {
        
        placeholderView.frame = CGRect(x: 5, y: 5, width: width, height: 30)
        addSubview(placeholderView)
        placeholderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickPlaceholderView)))
    }
}
