//
//  SwiftUIView.swift
//
//
//  Created by AL Reyes on 2/15/23.
//

import SwiftUI

public struct ChatNameAndTime<Message: ChatMessage>: View {
    public let message: Message
    public var tappedResendAction : (Message) -> Void
    @State private var showReactions = false

    public var body: some View {
        Group {
            VStack(spacing:0) {
                HStack(alignment: .center, spacing : 5){
                    if !message.isSender {
                        VStack(alignment: .leading, spacing: 5){
                            HStack(alignment: .center, spacing: 5){
                                timeStamp
                                actionStatus
                            }
                        }
                        
                    }else{
                        
                        VStack(alignment: .leading, spacing: 5){
                            HStack(alignment: .center, spacing: 5){
                                switch message.status {
                                case .failed:
                                    Group {
                                        Text("Re-Send")
                                            .font(.system(size: 10))
                                            .fontWeight(.medium)
                                            .foregroundColor(.red)
                                            .italic()
                                        Image(systemName: "arrow.counterclockwise.circle")
                                            .font(.system(size: 12))
                                            .frame(maxWidth: 8, maxHeight: 8,alignment: .center)
                                            .foregroundColor(.red)
                                    }
                                    .onTapGesture {
                                        self.tappedResendAction(message)
                                    }
                                    
                                case .sending:
                                    Text("Sending... ")
                                        .font(.system(size: 10))
                                        .fontWeight(.medium)
                                        .foregroundColor(.gray)
                                        .italic()
                                    Image(systemName: "paperplane")
                                        .font(.system(size: 10))
                                        .frame(maxWidth: 8, maxHeight: 8,alignment: .center)
                                        .foregroundColor(.gray)
                                    actionStatus
                                case .sent:
                                    
                                    switch message.messageKind {
                                    case .text(_, _,_, _,  _, let actionItemStatus,let reactions,let isFollowUP),
                                        .image(_, _,_, _, let actionItemStatus,let reactions,let isFollowUP),
                                        .imageText(_, _,_, _, _, _, let actionItemStatus,let reactions,let isFollowUP),
                                        .video(_, _,_, _, let actionItemStatus,let reactions,let isFollowUP),
                                        .videoText(_, _,_, _, _, _, let actionItemStatus,let reactions,let isFollowUP),
                                        .reply(_, _,_, _, _, let actionItemStatus,let reactions,let isFollowUP),
                                        .pdf(_, _,_, _, _, _, _, let actionItemStatus,let reactions,let isFollowUP),
                                        .audio(_, _,_, _, let actionItemStatus,let reactions,let isFollowUP)
                                        
                                        :
                                        if let actionItemStatus = actionItemStatus {
                                            timeStamp
                                            Text(actionItemStatus.body.uppercased())
                                                .foregroundColor(actionItemStatus.foregroundColor)
                                                .font(.system(size: 10))
                                                .fontWeight(.regular)
                                            Image(systemName: actionItemStatus.logo)
                                                .font(.system(size: 10))
                                                .frame(maxWidth: 8, maxHeight: 8,alignment: .center)
                                                .foregroundColor(actionItemStatus.foregroundColor)
                                                .padding(.horizontal,10)

                                        }else{
                                            sentNormalStatus
                                        }

                                    default:
                                        sentNormalStatus
                                    }
                                }

                            }

                        }

                    }
                }.frame(maxWidth: .infinity, alignment: message.isSender ?  .trailing : .leading)
                if let seenRecipients = message.seenRecipients, !seenRecipients.isEmpty {
                    HStack {
                        Spacer()
                        SeenAvatarsView(users: seenRecipients)
                            .padding(.trailing, 10)
                            .padding(.top, 5)
                    }
                }
            }

        }
        .padding(message.isSender ? .trailing : .leading ,message.isSender ? 10 : 45)
        .padding(.bottom, (message.seenRecipients?.isEmpty ?? true) ? 10 : 0)
    }
    
    private var timeStamp : some View {
        Text(message.date.dateFormat())
            .font(.system(size: 10))
            .fontWeight(.regular)
            .foregroundColor(.blue)
    }
    
    private var currentUser : some View {
        Text("• \(message.user.userName)")
            .font(.system(size: 10))
            .fontWeight(.regular)
    }
    
    private var actionStatus: some View {
        HStack(spacing: 5) {
            if !message.isSender {
                currentUser
            }

            switch message.messageKind {
            case .text(_, _,_, _, _, let actionItemStatus, _,_),
                 .image(_, _,_, _, let actionItemStatus, _,_),
                 .imageText(_, _,_, _, _, _, let actionItemStatus, _,_),
                 .video(_, _,_, _, let actionItemStatus, _,_),
                 .videoText(_, _,_, _, _, _, let actionItemStatus, _,_),
                 .reply(_, _,_, _, _, let actionItemStatus, _,_),
                 .pdf(_, _,_, _, _, _, _, let actionItemStatus, _,_),
                 .audio(_, _,_, _, let actionItemStatus, _,_):
                if let actionItemStatus = actionItemStatus {
                    actionStatusView(for: actionItemStatus)
                } else {
                    EmptyView()
                }
            default:
                EmptyView()
            }
        }
    }
    
    
    private var sentNormalStatus : some View {
        HStack(spacing : 5) {
            Text(message.date.dateFormat())
                .font(.system(size: 10))
                .fontWeight(.regular)
                .foregroundColor(.blue)
            Image(systemName: "paperplane.fill")
                .font(.system(size: 10))
                .frame(maxWidth: 8, maxHeight: 8,alignment: .center)
                .foregroundColor(.blue)
                .padding(.horizontal,10)
        }
    }
    
    private func actionStatusView(for status: ActionItemStatus) -> some View {
        HStack(spacing: 5) {
            Text(status.body.uppercased())
                .foregroundColor(status.foregroundColor)
                .font(.system(size: 10))
                .fontWeight(.regular)

            Image(systemName: status.logo)
                .font(.system(size: 10))
                .frame(maxWidth: 8, maxHeight: 8, alignment: .center)
                .foregroundColor(status.foregroundColor)
                .padding(.horizontal, 10)
        }
    }
    
}
