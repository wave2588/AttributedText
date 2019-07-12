![img](http://oysf.vip/Artboard.png)

<p align="center">
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-swift5-f48041.svg?style=flat"></a>
<a href="https://developer.apple.com/ios"><img src="https://img.shields.io/badge/platform-iOS%2010%2B-blue.svg?style=flat"></a>
<a href="http://cocoadocs.org/docsets/GSRefresh"><img src="https://img.shields.io/badge/Cocoapods-compatible-4BC51D.svg?style=flat"></a>
<a href="https://github.com/wxxsw/GSRefresh/blob/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat"></a>
<a href="https://github.com/wxxsw/GSRefresh/tree/0.5.5"><img src="https://img.shields.io/badge/release-1.0.1-blue.svg"></a>
</p>


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![img](http://oysf.vip/text.gif)

#### AttributedTextView
###### Insert single tag
```swift
let textView = AttributedTextView()
let model = TextModel(id: "id-0", text:"hashtag", symbolStr: "#", image: nil, type: 0)
textView.insertSpecialText(model: model, isDeleteLastString: false)
```

###### Parsing tag string
```swift
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
```swift
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
