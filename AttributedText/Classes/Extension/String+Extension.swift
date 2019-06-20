//
//  String+Extension.swift
//  AttributedText
//
//  Created by wave on 2019/6/20.
//

import Foundation

extension String {
    
    var utf8ConvertUnicodeStr: String {
        
        guard let data = self.data(using: .nonLossyASCII) else { return "" }
        let text = String(data: data, encoding: .utf8)
        return text ?? ""
    }
    
    var unicodeConvertUtf8: String {
        
        guard let datadec = data(using: .utf8) else { return "" }
        return String(data: datadec, encoding: .nonLossyASCII) ?? ""
    }
    
    func matchingStrings(regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        
        let nsString = self as NSString
        
        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        var strings: [String] = []
        
        for match in matches {
            for i in 0 ..< match.numberOfRanges {
                let range = match.range(at: i)
                guard range.location != NSNotFound else { continue }
                let string = nsString.substring(with: range)
                guard !string.isEmpty else { continue }
                strings.append(string)
            }
        }
        return strings
    }
}
