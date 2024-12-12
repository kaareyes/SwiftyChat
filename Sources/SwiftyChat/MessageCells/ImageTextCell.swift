//
//  ImageTextCell.swift
//
//
//  Created by Karl Söderberg on 25.10.2021.
//
//

import SwiftUI

internal struct ImageTextCell<Message: ChatMessage>: View {
    
    public let message: Message
    public let attentions: [String]?
    public let imageLoadingType: ImageLoadingKind
    public let text: String
    public let size: CGSize
    public let priority: MessagePriorityLevel
    public let actionStatus: ActionItemStatus?
    public let didTappedViewTask : (Message) -> Void
    @State private var showFullText = false

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
        return result +  text.phoneAndHtmlAttribute(style: cellStyle.textStyle)
    }
    private var maxWidth: CGFloat {
        size.width * (UIDevice.isLandscape ? 0.6 : 0.75)
    }
    
    private var imageWidth: CGFloat {
        cellStyle.cellWidth(size)
    }
    
    private var cellStyle: ImageTextCellStyle {
        style.imageTextCellStyle
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
        VStack(alignment: .leading, spacing: 0) {
            imageView
            if #available(iOS 15, *) {
                Text(formattedTagString)
                    .lineLimit(showFullText ? nil : 20)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(cellStyle.textPadding)

                if String(formattedTagString.characters).computeLineCount(containerWidth: maxWidth) > 20 {
                    showMore
                }
            } else {
                if #available(iOS 15.0, *) {
                    Text(text.phoneAndHtmlAttribute(style: cellStyle.textStyle))
                        .lineLimit(showFullText ? nil : 20)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(cellStyle.textPadding)
                    if String(text.phoneAndHtmlAttribute(style: cellStyle.textStyle).characters).computeLineCount(containerWidth: maxWidth) > 20 {
                        showMore
                    }
                } else {
                    Text(text.cleanHtml)
                        .fontWeight(cellStyle.textStyle.fontWeight)
                        .lineLimit(showFullText ? nil : 20)
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
}

