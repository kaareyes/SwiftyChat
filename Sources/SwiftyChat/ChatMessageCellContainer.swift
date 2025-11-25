//
//  MessageCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

internal struct ChatMessageCellContainer<Message: ChatMessage>: View {
    @EnvironmentObject var style: ChatMessageCellStyle
    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }
    public let message: Message
    public let size: CGSize
    
    public let onQuickReplyItemSelected: (QuickReplyItem) -> Void
    public let contactFooterSection: (ContactItem, Message) -> [ContactCellButton]
    public let onTextTappedCallback: () -> AttributedTextTappedCallback
    public let onCarouselItemAction: (CarouselItemButton, Message) -> Void
    public let didTappedMedia: (String,Message) -> Void
    public let didTappedViewTask: (Message) -> Void
    public var didTappedReaction : (Message) -> Void


    @ViewBuilder private func messageCell() -> some View {
        
        switch message.messageKind {
            
        case .text(let isUrgent, let isAttention,let text, let attentions, let priorityLevel, let actionStatus,let reactions , let followUp):
            TextCell(
                isUrgent: isUrgent,
                isAttention: isAttention,
                text: text,
                attentions: attentions,
                message: message,
                size: size,
                priority: priorityLevel,
                actionStatus:actionStatus,
                callback: onTextTappedCallback,
                didTappedViewTask: didTappedViewTask
            )
            
        case .location(let location):
            LocationCell(
                location: location,
                message: message,
                size: size
            )
            
        case .imageText(let isUrgent, let isAttention,let imageLoadingType, let text, let attentions, let priorityLevel, let actionStatus,let reactions, let followUp):
            ImageTextCell(
                isUrgent: isUrgent,
                isAttention: isAttention,
                message: message,
                attentions: attentions,
                imageLoadingType: imageLoadingType,
                text: text,
                size: size,
                priority:priorityLevel,
                actionStatus:actionStatus,
                didTappedViewTask : didTappedViewTask
            )
            
        case .image(let isUrgent, let isAttention,let imageLoadingType, let priorityLevel, let actionStatus,let reactions, let followUp):
            ImageCell(
                isUrgent: isUrgent,
                isAttention: isAttention,
                message: message,
                imageLoadingType: imageLoadingType,
                size: size,
                priority: priorityLevel,
                actionStatus: actionStatus,
                didTappedViewTask : didTappedViewTask
            )
            
        case .contact(let contact):
            ContactCell(
                contact: contact,
                message: message,
                size: size,
                footerSection: contactFooterSection
            )
            
        case .quickReply(let quickReplies):
            QuickReplyCell(
                quickReplies: quickReplies,
                quickReplySelected: onQuickReplyItemSelected
            )
            
        case .carousel(let carouselItems):
            CarouselCell(
                carouselItems: carouselItems,
                size: size,
                message: message,
                onCarouselItemAction: onCarouselItemAction
            )
            
        case .video(let isUrgent, let isAttention,let videoItem, let priorityLevel, let actionStatus,let reactions, let followUp):
            VideoPlaceholderCell(
                isUrgent: isUrgent,
                isAttention: isAttention,
                media: videoItem,
                message: message,
                size: size,
                priority: priorityLevel,
                actionStatus : actionStatus,
                didTappedViewTask : didTappedViewTask
            )
            
        case .loading:
            LoadingCell(message: message, size: size)
        case .systemMessage(let text):
            SystemMessageCell(text: text,message: message)
        
        case .videoText(let isUrgent, let isAttention,let videoItem, let text, let attentions, let priorityLevel, let actionStatus,let reactions, let followUp):
            SystemMessageCell(text: text,message: message)
            
        case .reply(let isUrgent, let isAttention,let reply, let replies, let priorityLevel, let actionStatus,let reactions, let followUp):
            ReplyCell(isUrgent: isUrgent,
                      isAttention: isAttention,
                      message: message,
                      replies: replies,
                      reply: reply,
                      size: size,
                      priority: priorityLevel,
                      actionStatus : actionStatus,
                      didTappedMedia: didTappedMedia,
                      didTappedViewTask : didTappedViewTask)
        
        case .pdf(let isUrgent, let isAttention,let image, let text, let attentions, let pdfURL, let priorityLevel, let actionStatus,let reactions, let followUp):
            PdfTextCell(isUrgent: isUrgent,
                        isAttention: isAttention,
                        message: message,
                        attentions: attentions,
                        imageLoadingType: image,
                        pdfURL: pdfURL,
                        text: text,
                        size: size,
                        priority: priorityLevel,
                        actionStatus : actionStatus,
                        didTappedViewTask : didTappedViewTask)
            
        case .audio(let isUrgent, let isAttention,let url, let priorityLevel, let actionStatus,let reactions,let followUp):
            
           AudioCell(isUrgent: isUrgent,
                     isAttention: isAttention,
                     message: message,
                     audioURL: url,
                     size: size,
                     priority: priorityLevel,
                     actionStatus:actionStatus,
                     didTappedViewTask:didTappedViewTask)

        }
        
    }
    
    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            messageCell()
            reactionListView
                .offset(x: 0, y: 20) // adjust values as needed
        }
        .allowsHitTesting(true)
    }
    
    private var reactionButtonView: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(cellStyle.cellBackgroundColor)
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .padding(2)
                )

        }
        .onTapGesture {
            self.didTappedReaction(message)
        }
        .onLongPressGesture {
            withAnimation {
                self.didTappedReaction(message)
            }
        }
        .padding(.horizontal,5)
    }
    
    
    private var followupbutton: some View {
        HStack(spacing: 6) {
            // "Follow up" pill
            Text("Follow up")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.black)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(cellStyle.cellBackgroundColor, lineWidth: 1)
                        )
                )
        }
        .padding(.horizontal, 5)
        .onTapGesture {
            self.didTappedReaction(message)
        }
        .onLongPressGesture {
            withAnimation {
                self.didTappedReaction(message)
            }
        }
    }
    
    
    private var reactionListView: some View {
        switch message.messageKind {
        case .text(_, _,_, _, _, _, let reactions,let isFollowUP),
             .image(_, _,_, _, _, let reactions,let isFollowUP),
             .imageText(_, _,_, _, _, _, _, let reactions,let isFollowUP),
             .video(_, _,_, _, _, let reactions,let isFollowUP),
             .videoText(_, _,_, _, _, _, _, let reactions,let isFollowUP),
             .reply(_, _,_, _, _, _, let reactions,let isFollowUP),
             .pdf(_, _,_, _, _, _, _, _, let reactions,let isFollowUP),
             .audio(_, _,_, _, _, let reactions,let isFollowUP):

            if let reactions = reactions, !reactions.isEmpty {
                let reactionItem = ReactionItem(reactions: reactions)
                return AnyView(
                    HStack(spacing: 5) {
                        ForEach(reactionItem.emojis, id: \.emoji) { item in
                            HStack(spacing: 4) {
                                Text(item.emoji)
                                    .font(.system(size: 12))
                                Text("\(item.count)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(cellStyle.cellBackgroundColor)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        }
                        reactionButtonView
                        if isFollowUP {
                            followupbutton
                        }
                        
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.clear)
                    .clipShape(Capsule())
                    .shadow(radius: 2)
                )
            }else{
                return AnyView(HStack(spacing: 5) {
                    reactionButtonView
                    if isFollowUP {
                        followupbutton
                    }
                })
            }

        default:
            break
        }

        return AnyView(EmptyView())
    }
    
}
