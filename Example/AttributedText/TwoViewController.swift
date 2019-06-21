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
    
    @IBOutlet weak var textView: InputTextView!
    
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = AttributedTextConfig(pattern: "#\\u200b.*?\\u200b", separatorKey: "|")
        textView.config = config
        textView.modelMapper = { text -> TextViewModel? in
            
            let splits = text.split(separator: Character(config.separatorKey))

            guard
                splits.count >= 4,
                let id = splits[safe: 1]?.description,
                let type = splits[safe: 2]?.description.int,
                let text = splits[safe: 3]?.description
                else { return nil }

            switch type {
            case 0:     return TextViewModel(id: id, text: text, symbolStr: "#", image: nil, type: type)
            case 1:     return TextViewModel(id: id, text: text, symbolStr: "@", image: nil, type: type)
            default:    return TextViewModel(id: id, text: text, symbolStr: nil, image: #imageLiteral(resourceName: "location"), type: type)
            }
        }
        textView.set(text: text)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}
