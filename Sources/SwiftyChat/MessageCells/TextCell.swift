//
//  TextCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

internal struct TextCell<Message: ChatMessage>: View {
    
    public let text: String
    public let attentions : [String]?
    public let message: Message
    public let size: CGSize
    public let priority: MessagePriorityLevel
    public let actionStatus: ActionItemStatus?
    public let callback: () -> AttributedTextTappedCallback
    public let didTappedViewTask : (Message) -> Void
    @State private var showFullText = false
    
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }
    
    private let enabledDetectors: [DetectorType] = [
        .address, .date, .phoneNumber, .url, .transitInformation
    ]
    
    private var maxWidth: CGFloat {
        size.width * (UIDevice.isLandscape ? 0.6 : 0.75)
    }
    
    private var action: AttributedTextTappedCallback {
        return callback()
    }
    
    
    
    
    
    private var showMore : some View {
        HStack {
            Spacer()
            Button(action: {
                showFullText.toggle() // Toggle between showing full text a     nd truncated text
            }) {
                Text(showFullText ? "Show less" : "Show more")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
            }
            .padding(.trailing)
            .padding(.bottom)
        }
    }
    
    
    
    // MARK: - Default Text
    private var defaultText: some View {
        VStack(alignment: .leading) {
            Text(text)
                .fontWeight(cellStyle.textStyle.fontWeight)
                .lineLimit(showFullText ? nil : 20)
                .modifier(EmojiModifier(text: text, defaultFont: cellStyle.textStyle.font))
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(cellStyle.textStyle.textColor)
                .padding(cellStyle.textPadding)
            
            if self.computeLineCount(for: text, with: cellStyle) > 20 {
                showMore
            }
            
            HStack(){
                
                if let status = actionStatus {
                    PriorityMessageViewStyle(priorityLevel: priority)
                        .padding(.bottom,10)
                        .padding(.trailing,10)
                        .padding(.leading,10)
                        .frame(alignment: .leading)
                        .shadow (
                            color: cellStyle.cellShadowColor,
                            radius: cellStyle.cellShadowRadius
                        )
                    Spacer()
                    TaskMessageViewSytle(status: status)
                        .padding(.bottom,10)
                        .padding(.trailing,10)
                        .padding(.leading,10)
                        .frame(alignment: .trailing)
                        .shadow (
                            color: cellStyle.cellShadowColor,
                            radius: cellStyle.cellShadowRadius
                        )
                        .onTapGesture(perform: {
                            self.didTappedViewTask(self.message)
                        })
                }
            }
            
            
            
        }
        .background(cellStyle.cellBackgroundColor)
        .clipShape(RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners))
        .overlay(
            
            RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners)
                .stroke(
                    cellStyle.cellBorderColor,
                    lineWidth: cellStyle.cellBorderWidth
                )
                .shadow(
                    color: cellStyle.cellShadowColor,
                    radius: cellStyle.cellShadowRadius
                )
        )
    }
    @available(iOS 15, *)
    private var defaultTextiOS15: some View {
        
        VStack(alignment: .leading) {
            Text(attributedText)
            //       .fontWeight(cellStyle.textStyle.fontWeight)
                .lineLimit(showFullText ? nil : 20)
                .modifier(EmojiModifier(text: String(attributedText.characters), defaultFont: cellStyle.textStyle.font))
                .fixedSize(horizontal: false, vertical: true)
            //     .foregroundColor(cellStyle.textStyle.textColor)
                .padding(cellStyle.textPadding)
            
            if self.computeLineCount(for: String(attributedText.characters), with: cellStyle) > 20 {
                showMore
            }
            
            
            HStack(){
                
                if let status = actionStatus {
                    PriorityMessageViewStyle(priorityLevel: priority)
                        .padding(.bottom,10)
                        .padding(.trailing,10)
                        .padding(.leading,10)
                        .frame(alignment: .leading)
                        .shadow (
                            color: cellStyle.cellShadowColor,
                            radius: cellStyle.cellShadowRadius
                        )
                    Spacer()
                    TaskMessageViewSytle(status: status)
                        .padding(.bottom,10)
                        .padding(.trailing,10)
                        .padding(.leading,10)
                        .frame(alignment: .trailing)
                        .shadow (
                            color: cellStyle.cellShadowColor,
                            radius: cellStyle.cellShadowRadius
                        )
                        .onTapGesture(perform: {
                            self.didTappedViewTask(self.message)
                        })
                }
            }
            
        }
        .background(cellStyle.cellBackgroundColor)
        .clipShape(RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners))
        .overlay(
            
            RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners)
                .stroke(
                    cellStyle.cellBorderColor,
                    lineWidth: cellStyle.cellBorderWidth
                )
                .shadow(
                    color: cellStyle.cellShadowColor,
                    radius: cellStyle.cellShadowRadius
                )
        )
    }
    
    
    private func computeLineCount(for text: String, with style: TextCellStyle) -> Int {
        //Font what is Font in swiftUI
        let systemFont = UIFont.preferredFont(forTextStyle: .body) // You can change .body to any other text style
        let fontSize: CGFloat = systemFont.pointSize // Assuming you have a font size in your style
        let averageCharacterWidth: CGFloat = fontSize * 0.5 // This is a rough estimate
        let containerWidth: CGFloat = maxWidth // Use the calculated maxWidth for the text container
        let charactersPerLine = max(1, containerWidth / averageCharacterWidth)
        let lineCount = Int(ceil(CGFloat(text.count) / charactersPerLine))
        return lineCount
    }
    
    @available(iOS 15, *)
    private var formattedTagString : AttributedString {
        var attentionName : String = ""
        if let attentions = attentions {
            for name in attentions {
                attentionName += "@\(name) "
            }
        }
        
        var result = AttributedString(attentionName)
        result.foregroundColor = .blue
        
        
        
        return result + text.phoneAndHtmlAttribute(style: cellStyle.textStyle)
    }
    @available(iOS 15, *)
    private var attributedText: AttributedString {
        return text.phoneAndHtmlAttribute(style: cellStyle.textStyle)
    }
    
    @available(iOS 15, *)
    private var defaultAttentionText: some View {
        
        VStack(alignment: .leading) {
            Text(formattedTagString)
                .lineLimit(showFullText ? nil : 20)
                .modifier(EmojiModifier(text: String(formattedTagString.characters), defaultFont: cellStyle.textStyle.font))
                .fixedSize(horizontal: false, vertical: true)
                .padding(cellStyle.textPadding)
            if self.computeLineCount(for: String(formattedTagString.characters), with: cellStyle) > 20 {
                showMore
            }
            
            
            HStack(){
                
                if let status = actionStatus {
                    PriorityMessageViewStyle(priorityLevel: priority)
                        .padding(.bottom,10)
                        .padding(.trailing,10)
                        .padding(.leading,10)
                        .frame(alignment: .leading)
                        .shadow (
                            color: cellStyle.cellShadowColor,
                            radius: cellStyle.cellShadowRadius
                        )
                    Spacer()
                    TaskMessageViewSytle(status: status)
                        .padding(.bottom,10)
                        .padding(.trailing,10)
                        .padding(.leading,10)
                        .frame(alignment: .trailing)
                        .shadow (
                            color: cellStyle.cellShadowColor,
                            radius: cellStyle.cellShadowRadius
                        )
                        .onTapGesture(perform: {
                            self.didTappedViewTask(self.message)
                        })
                }
            }
            
        }
        .background(cellStyle.cellBackgroundColor)
        .clipShape(RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners))
        .overlay(
            
            RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners)
                .stroke(
                    cellStyle.cellBorderColor,
                    lineWidth: cellStyle.cellBorderWidth
                )
                .shadow(
                    color: cellStyle.cellShadowColor,
                    radius: cellStyle.cellShadowRadius
                )
        )
    }
    
    @ViewBuilder public var body: some View {
        if let attentions = attentions, attentions.count > 0 {
            if #available(iOS 15, *) {
                defaultAttentionText
            } else {
                defaultText
            }
        }else{
            if #available(iOS 15, *) {
                defaultTextiOS15
            }else{
                defaultText
            }
        }
        
        
        
    }
}

internal struct AttributedTextPhone: Hashable {
    let string: String
    let isPhoneNumber: Bool
}
