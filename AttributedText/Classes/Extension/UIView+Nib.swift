//
//  UIView+Nib.swift
//  AttributedText
//
//  Created by wave on 2019/6/20.
//

import Foundation
import SwifterSwift

extension UIView {
    
    static func fromNib<T: UIView>() -> T {
        
        let path = Bundle.main.path(forResource: "Frameworks/AttributedText", ofType: "framework")
        let bundle = Bundle(path: path!)
        
        let name = String(describing: self)
        let view = UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil).first as! T
        return view
    }

}
