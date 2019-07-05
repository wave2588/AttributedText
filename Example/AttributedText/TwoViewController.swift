//
//  TwoViewController.swift
//  AttributedText_Example
//
//  Created by wave on 2019/6/20.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import AttributedText

class TwoViewController: UIViewController {

    deinit { debugPrint("deinit \(self)") }
    
    @IBOutlet weak var textView: AttributedTextView!
    
    @IBOutlet weak var label: AttributedLabel!
    
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.modelMapper = { text -> TextModel? in
            let splits = text.split()
            
            guard
                splits.count >= 4,
                let id = splits[safe: 1]?.description,
                let type = splits[safe: 2]?.description.int,
                let text = splits[safe: 3]?.description
                else { return nil }
            
            switch type {
            case 0:     return TextModel(id: id, text: text, symbolStr: "#", image: nil, type: type)
            case 1:     return TextModel(id: id, text: text, symbolStr: "@", image: nil, type: type)
            default:    return TextModel(id: id, text: text, symbolStr: nil, image: #imageLiteral(resourceName: "location"), type: type)
            }
        }
        
        label.clickLink = { model in
            guard let m = model else { return }
            debugPrint(m.text)
        }
        debugPrint(222, label.formatText(text: text))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let defaultAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle,
        ]
        let attr = NSAttributedString(string: text, attributes: defaultAttributes)
        label.set(attributedString: attr)
        
        textView.modelMapper = { text -> TextModel? in
            
            let splits = text.split()

            guard
                splits.count >= 4,
                let id = splits[safe: 1]?.description,
                let type = splits[safe: 2]?.description.int,
                let text = splits[safe: 3]?.description
                else { return nil }
            
            switch type {
            case 0:     return TextModel(id: id, text: text, symbolStr: "#", image: nil, type: type)
            case 1:     return TextModel(id: id, text: text, symbolStr: "@", image: nil, type: type)
            default:    return TextModel(id: id, text: text, symbolStr: nil, image: #imageLiteral(resourceName: "location"), type: type)
            }
        }
        textView.set(text: text)
    }
    
    @IBAction func clickDismissButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
