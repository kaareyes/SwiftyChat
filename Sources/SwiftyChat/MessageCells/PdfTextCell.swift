//
//  File.swift
//  
//
//  Created by AL Reyes on 6/15/23.
//

import SwiftUI

internal struct PdfTextCell<Message: ChatMessage>: View {
    public let isUrgent: Bool
    public let isAttention: Bool
    public let message: Message
    public let attentions: [String]?
    public let imageLoadingType: ImageLoadingKind
    public let pdfURL: URL
    public let text: String
    public let size: CGSize
    public let priority: MessagePriorityLevel
    public let actionStatus: ActionItemStatus?
    public let didTappedViewTask : (Message) -> Void

    @EnvironmentObject var style: ChatMessageCellStyle
    
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
    
    private var hasText : Bool {
        if let attentions = attentions, attentions.count > 0 {
            return true
        }

        if text.count > 0{
            return true
        }
        return false
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

    private var backgroundColor: Color {
                
       if isUrgent {
           return BubbleColorStyle.urgentColor
        }else if isAttention {
            return BubbleColorStyle.attentionColor
       }
        return cellStyle.cellBackgroundColor
    }
    
    
    private var imageWidth: CGFloat {
        cellStyle.cellWidth(size)
    }
    
    private var cellStyle: ImageTextCellStyle {
        style.imageTextCellStyle
    }
    
    @ViewBuilder private var imageView: some View {
        
        if case let ImageLoadingKind.local(uiImage) = imageLoadingType {
            let width = uiImage.size.width
            let height = uiImage.size.height
            let isLandscape = width > height
            ImageLoadingKindCell(
                imageLoadingType,
                width: imageWidth,
                height: isLandscape ? nil : height * (imageWidth / width)
            )
        } else {
            ImageLoadingKindCell(
                imageLoadingType,
                width: imageWidth
            )
        }
    }
    
    @ViewBuilder public var body: some View {
                
        if hasText {
            VStack(alignment: .leading, spacing: 0) {
                imageView
                if #available(iOS 15, *) {
                    Text(formattedTagString)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(cellStyle.textPadding)

                } else {
                    
                    if #available(iOS 15.0, *) {
                        Text(text.phoneAndHtmlAttribute(style: cellStyle.textStyle))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(cellStyle.textPadding)

                    }else {
                        Text(text.cleanHtml)
                            .fontWeight(cellStyle.textStyle.fontWeight)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(cellStyle.textStyle.textColor)
                            .padding(cellStyle.textPadding)

                        
                    }
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
                .background(backgroundColor)
                
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
        }else{
            
            VStack(alignment: .leading, spacing: 0) {
                imageView
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
            .background(backgroundColor)
            .cornerRadius(cellStyle.cellCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cellStyle.cellCornerRadius)
                    .stroke(
                        cellStyle.cellBorderColor,
                        lineWidth: cellStyle.cellBorderWidth
                    )
            )
            .shadow (
                color: cellStyle.cellShadowColor,
                radius: cellStyle.cellShadowRadius
            )
        }
        
        

    }
    
}
