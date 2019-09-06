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

    @IBOutlet weak var textView: AttributedTextView!
    
    /// special text style
    public var linkAttributes: [NSAttributedString.Key : Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
 
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        linkAttributes = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 15, weight: .medium),
            .foregroundColor: UIColor(red: 69, green: 144, blue: 229) ?? .black
        ]
        
        textView.textChanged = { text in
            debugPrint(text)
        }
    }
    
    @IBAction func clickHashtagAction(_ sender: Any) {

        let model = TextModel(id: "id-0", symbol: "#", text:"话题标签", image: nil, imageLocation: nil, type: 0, attributes: linkAttributes)
        textView.insertSpecialText(model: model, isDeleteLastString: false)
    }
    
    @IBAction func clickMemberAction(_ sender: Any) {
        
        let model = TextModel(id: "id-1", symbol: "@",text:"人物标签", image: nil, imageLocation: nil, type: 1, attributes: linkAttributes)
        textView.insertSpecialText(model: model, isDeleteLastString: false)
    }
    
    @IBAction func clickLocationAction(_ sender: Any) {
        
        let model = TextModel(id: "id-2", symbol: nil,text:"位置标签", image: #imageLiteral(resourceName: "database"), imageLocation: .right, type: 2, attributes: linkAttributes)
        textView.insertSpecialText(model: model, isDeleteLastString: false)
    }
    
    @IBAction func clickNextAction(_ sender: Any) {

        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withClass: TwoViewController.self) {
            
            vc.text = textView.outputs.hashtagText
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}

