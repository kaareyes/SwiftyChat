//
//  File.swift
//  SwiftyChat
//
//  Created by 1gz on 2/27/25.
//
import SwiftUI

class FormattedLinkManager {
    
    @available(iOS 15, *)
    static func formattedAttributedString(from attributedText: AttributedString) -> AttributedString {
        var mutableAttributedText = attributedText
        let detectedLinks = detectLinks(in: String(attributedText.characters))
        
        for link in detectedLinks {
            if let range = mutableAttributedText.range(of: link) {
                mutableAttributedText[range].foregroundColor = .blue
                mutableAttributedText[range].underlineStyle = .single
                //
                let formattedLink = formatURL(link)
                mutableAttributedText[range].link = URL(string: formattedLink)
                
                if link.lowercased().contains(".pdf") {
                    if let url = URL(string: link), url.pathComponents.last?.lowercased().hasSuffix(".pdf") == true {
                        let fileName = url.lastPathComponent
                        mutableAttributedText.replaceSubrange(range, with: AttributedString(fileName))
                        if let newRange = mutableAttributedText.range(of: fileName) {
                            mutableAttributedText[newRange].foregroundColor = .blue
                            mutableAttributedText[newRange].underlineStyle = .single
                            mutableAttributedText[newRange].link = URL(string: formattedLink)
                        }
                    }
                }
            }
        }
        
        return mutableAttributedText
    }
    /// Ensures URLs have the correct format (adds "https://" if missing)
    /// - Parameter link: The raw detected link
    /// - Returns: A properly formatted URL string
    private static func formatURL(_ link: String) -> String {
        if link.hasPrefix("http://") || link.hasPrefix("https://") {
            return link
        } else {
            return "https://\(link)"
        }
    }
    
    /// Detects links in a string using regular expressions.
    /// - Parameter text: The input string
    /// - Returns: An array of detected URLs in string format
    private static func detectLinks(in text: String) -> [String] {
        let regexPattern = #"(?i)\b((?:https?:\/\/|www\.)?[a-z0-9.-]+\.[a-z]{2,}\b(?:\/[^\s]*)?)"#
        
        do {
            let regex = try NSRegularExpression(pattern: regexPattern, options: [])
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
            
            return matches.compactMap { match in
                guard let range = Range(match.range, in: text) else { return nil }
                return String(text[range])
            }
        } catch {
            print("Regex error: \(error.localizedDescription)")
            return []
        }
    }
}
