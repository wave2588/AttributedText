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
        
        label.modelMapper = { [unowned self] text -> TextModel? in
            let splits = text.split()
            
            guard
                splits.count >= 4,
                let id = splits[safe: 1]?.description,
                let type = splits[safe: 2]?.description.int,
                let text = splits[safe: 3]?.description
                else { return nil }
            
            switch type {
//            case 0:     return TextModel(id: id, text: text, symbolStr: "#", image: nil, type: type)
            case 1:     return TextModel(id: id, symbol: "@", text: text, image: nil, imageLocation: nil,type: type, attributes: self.linkAttributes)
            case 2:     return TextModel(id: id, symbol: nil, text: text, image: #imageLiteral(resourceName: "database"), imageLocation: .right, type: type, attributes: self.linkAttributes)
            default:    return nil
            }
        }
        
        label.clickLink = { model in
//            guard let m = model else { return }
//            debugPrint(m.text)
            if let _ = model {
                debugPrint("true")
            } else {
                debugPrint("false")
            }
        }

        label.ANumberOfLines = 2
        label.ALineBreakMode = .byTruncatingTail

        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing = 4
        let defaultAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle1,
        ]
        
        /// 正文
        /// fix: 用这一段正文会不这行
        let str = "圣托里尼的蓝顶教堂也太好拍了！ 伊亚镇建立在海边的悬崖上，地处希腊的王冠圣托里尼岛，是圣托里尼岛第二大镇，岛上最耀眼的明珠，也是一个拥有全世界最美的日落的地方，伊亚独特的石洞屋有白色门墙屋顶﹑蓝彩窗棂，再配上几盆红花，颇具基克拉泽斯群岛的建筑风格。这个美丽的魔力小镇吸引了很多艺术家来寻找创作的灵感。小镇商店里出售的每一件手工工艺品﹑艺廊里展出的每一幅作品都体现了设计者别具一格的品味，伊亚也因此堪称 \"艺术家的村落\"。"
        
        /// fix: 用这一段正文会两行后边都显示 "..."
//        let str = "最近的快乐，多半来自整理过去几年旅行的照片和短视频…很多记录，都几乎是拍完再也没打开过。\n疫情结束后，再去一趟杜马盖地，睡一宿海边的帐篷⛺️，听听海鸟清晨觅食的呼响，赴一场日出之约。如果再有二三小友，恰点小酒就更棒了。"
//        let str = "最近的快乐，多半来自整理过去几年旅行的照片和短视频…很多记录，都几乎是拍完再也没打开过。疫情结束后，再去一趟杜马盖地，睡一宿海边的帐篷⛺️，听听海鸟清晨觅食的呼响，赴一场日出之约。如果再有二三小友，恰点小酒就更棒了。"
        
//        let str = "哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"
        
//        let str = "转发一张ins上看到的玩具柜收藏。感觉很有启发，不仅仅是把玩具手办放到冰冷的玻璃柜里，而是通过装饰渲染整体的氛围，打造主题，让整体更好看"
        let attr = NSAttributedString(string: str, attributes: defaultAttributes)
        _ = label.set(attributedString: attr, isConverted: true)
        
        /// 名称
        let nameStyle = NSMutableParagraphStyle()
        nameStyle.lineSpacing = 4
        let nameAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .medium),
            .foregroundColor: UIColor.red,
            .paragraphStyle: nameStyle,
        ]
        
//        label.insertSpecialText(model: TextModel(id: "", symbol: nil, text: "@Name: ", image: nil, imageLocation: nil, type: 3, attributes: nameAttributes), location: 0)
        
//        private let contentNameStyle = StringStyle(.font(.systemFont(ofSize: 15, weight: .medium)), .color(UIColor(hex: 0xFFEA00)!), .lineSpacing(3))
//        private let contentTopicStyle = StringStyle(.font(.systemFont(ofSize: 15, weight: .medium)), .color(UIColor(hex: 0x32A5FF)!))
//        private let contentStyle = StringStyle(.font(.systemFont(ofSize: 15)), .color(UIColor.white))

        
        textView.modelMapper = { [unowned self] text -> TextModel? in
            
            let splits = text.split()
            
            guard
                splits.count >= 4,
                let id = splits[safe: 1]?.description,
                let type = splits[safe: 2]?.description.int,
                let text = splits[safe: 3]?.description
                else { return nil }
            
            switch type {
            case 0:     return TextModel(id: id, symbol: "#", text: text, image: nil, imageLocation: nil, type: type, attributes: self.linkAttributes)
            case 1:     return TextModel(id: id, symbol: "@", text: text, image: nil, imageLocation: nil, type: type, attributes: self.linkAttributes)
            default:
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                let linkAttributes: [NSAttributedString.Key : Any] = [
                    .paragraphStyle: paragraphStyle,
                    .font: UIFont.systemFont(ofSize: 15, weight: .medium),
                    .foregroundColor: UIColor.black
                ]
                return TextModel(id: id, symbol: nil, text: text, image: nil, imageLocation: nil, type: type, attributes: linkAttributes)
            }
        }
        textView.set(text: text)
    }
    
    @IBAction func clickAddLabelText(_ sender: UIButton) {
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing = 4
        let defaultAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle1,
        ]

        let model = TextModel(id: "id", symbol: nil, text: "查看", image: #imageLiteral(resourceName: "pin"), imageLocation: .left, type: 0, attributes: defaultAttributes)
        label.insertSpecialText(model: model, location: label.text?.count ?? 0)
    }
    
    @IBAction func clickDismissButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}
