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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.textChanged = { text in
            debugPrint(text)
        }
    }
    
    @IBAction func clickHashtagAction(_ sender: Any) {

        let model = TextModel(id: "id-0", text:"话题标签", symbolStr: "#", image: nil, type: 0)
        textView.insertSpecialText(model: model, isDeleteLastString: false)
    }
    
    @IBAction func clickMemberAction(_ sender: Any) {
        
        let model = TextModel(id: "id-1", text:"人物标签", symbolStr: "@", image: nil, type: 1)
        textView.insertSpecialText(model: model, isDeleteLastString: false)
    }
    
    @IBAction func clickLocationAction(_ sender: Any) {
        
        let model = TextModel(id: "id-2", text:"位置标签", symbolStr: nil, image: #imageLiteral(resourceName: "location"), type: 2)
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

