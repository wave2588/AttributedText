//
//  TextViewInserAttributeModel.swift
//  AttributedText
//
//  Created by wave on 2019/6/20.
//

import Foundation

struct TextViewInserAttributeModel {
    
    /// content length
    let length: Int
    
    /// TextModel
    let textModel: TextModel
    
    init(length: Int, textModel: TextModel) {
        self.length = length
        self.textModel = textModel
    }
}
