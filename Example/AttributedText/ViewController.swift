//
//  ViewController.swift
//  AttributedText
//
//  Created by wave2588 on 06/20/2019.
//  Copyright (c) 2019 wave2588. All rights reserved.
//

import UIKit
import AttributedText

class ViewController: UIViewController {

    @IBOutlet weak var textView: InputTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.textChanged = { text in
            debugPrint(text)
        }
    }
    
    @IBAction func clickHashtagAction(_ sender: Any) {

        let model = TextViewModel(id: "1", text:"我是话题标签", symbolStr: "#", image: nil, type: 1)
        textView.insertSpecialText(model: model, isDeleteLastString: false)
    }
    
    @IBAction func clickMemberAction(_ sender: Any) {
        
        let model = TextViewModel(id: "2", text:"我是人物标签", symbolStr: "@", image: nil, type: 2)
        textView.insertSpecialText(model: model, isDeleteLastString: false)
    }
    
    @IBAction func clickLocationAction(_ sender: Any) {
        
        let model = TextViewModel(id: "3", text:"我是位置标签", symbolStr: nil, image: #imageLiteral(resourceName: "location"), type: 3)
        textView.insertSpecialText(model: model, isDeleteLastString: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugPrint(textView.outputs.text)
        debugPrint(textView.outputs.hashtagText)
    }
}
