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
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(cellStyle.textStyle.textColor)
                .padding(cellStyle.textPadding)
            
            if text.computeLineCount(containerWidth: maxWidth) > 20 {
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
                .lineLimit(showFullText ? nil : 20)
                .fixedSize(horizontal: false, vertical: true)
                .padding(cellStyle.textPadding)
            
            if String(attributedText.characters).computeLineCount(containerWidth: maxWidth) > 20 {
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
    private var formattedTagString : AttributedString {
        var attentionName : String = ""
        if let attentions = attentions {
            for name in attentions {
                attentionName += "@\(name) "
            }
        }
        let baseUIFont = UIFont.systemFont(ofSize: 17, weight: uiFontWeight(from: cellStyle.textStyle.fontWeight))

        var result = AttributedString(attentionName)
        result.foregroundColor = .blue
        result.font = baseUIFont

        
        
        let combinedAttributedText = result + text.phoneAndHtmlAttribute(style: cellStyle.textStyle)
        return FormattedLinkManager.formattedAttributedString(from: combinedAttributedText)
    }
    
    
    
    @available(iOS 15, *)
    private var attributedText: AttributedString {
        
        let combinedAttributedText = text.phoneAndHtmlAttribute(style: cellStyle.textStyle)
        return FormattedLinkManager.formattedAttributedString(from: combinedAttributedText)
    }
    
    
    func uiFontWeight(from fontWeight: Font.Weight) -> UIFont.Weight {
        switch fontWeight {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        default: return .regular
        }
    }

    @available(iOS 15, *)
    private var defaultAttentionText: some View {
        
        VStack(alignment: .leading) {
            Text(formattedTagString)
                .lineLimit(showFullText ? nil : 20)
                .fixedSize(horizontal: false, vertical: true)
                .padding(cellStyle.textPadding)
            
            if String(formattedTagString.characters).computeLineCount(containerWidth: maxWidth) > 20 {
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
