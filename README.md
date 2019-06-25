# AttributedText

[![CI Status](https://img.shields.io/travis/wave2588/AttributedText.svg?style=flat)](https://travis-ci.org/wave2588/AttributedText)
[![Version](https://img.shields.io/cocoapods/v/AttributedText.svg?style=flat)](https://cocoapods.org/pods/AttributedText)
[![License](https://img.shields.io/cocoapods/l/AttributedText.svg?style=flat)](https://cocoapods.org/pods/AttributedText)
[![Platform](https://img.shields.io/cocoapods/p/AttributedText.svg?style=flat)](https://cocoapods.org/pods/AttributedText)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

#### AttributedTextView
```
/// insertModel
let textView = AttributedTextView()
let model = TextModel(id: "id-0", text:"hashtag", symbolStr: "#", image: nil, type: 0)
textView.insertSpecialText(model: model, isDeleteLastString: false)

/// setText
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
```


#### AttributedLabel
```
let label = AttributedLabel()
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

let paragraphStyle = NSMutableParagraphStyle()
paragraphStyle.lineSpacing = 4
let defaultAttributes: [NSAttributedString.Key : Any] = [
    .font: UIFont.systemFont(ofSize: 15),
    .foregroundColor: UIColor.black,
    .paragraphStyle: paragraphStyle,
]
let attr = NSAttributedString(string: text, attributes: defaultAttributes)
label.set(attributedString: attr)
```

## Requirements
Swift 5.0 or later

## Installation

AttributedText is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AttributedText'
```

## Author

wave, q.wavedev@gmail.com

## License

AttributedText is available under the MIT license. See the LICENSE file for more info.
