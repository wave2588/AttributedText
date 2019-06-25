//
//  AttributedTextPlaceholderView.swift
//  Label
//
//  Created by wave on 2019/3/15.
//  Copyright © 2019 wave. All rights reserved.
//

import UIKit

class AttributedTextPlaceholderView: UIView {

    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.text = "这一刻的想法…"
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
