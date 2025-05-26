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
    public var tappedReaction : () -> Void
    @State private var showReactions = false

    public var body: some View {
        Group {
            HStack(alignment: .center, spacing : 5){
                if !message.isSender {
                    VStack(alignment: .leading, spacing: 5){
                        HStack(alignment: .center, spacing: 5){
                            timeStamp
                            actionStatus
                            reactionButtonView
                                .padding(.leading,2)

                        }
                        reactionListView
                    }
                    
              
                }else{
                    reactionButtonView
                        .padding(.trailing,2)

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
                        case .text(_, _,  _, let actionItemStatus,let reactions),
                            .image(_, _, let actionItemStatus,let reactions),
                            .imageText(_, _, _, _, let actionItemStatus,let reactions),
                            .video(_, _, let actionItemStatus,let reactions),
                            .videoText(_, _, _, _, let actionItemStatus,let reactions),
                            .reply(_, _, _, let actionItemStatus,let reactions),
                            .pdf(_, _, _, _, _, let actionItemStatus,let reactions),
                            .audio(_, _, let actionItemStatus,let reactions)
                            
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
            }.frame(maxWidth: .infinity, alignment: message.isSender ?  .trailing : .leading)
        }
        .padding(message.isSender ? .trailing : .leading ,message.isSender ? 10 : 45)
        .padding(.bottom,20)
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
            case .text(_, _, _, let actionItemStatus, _),
                 .image(_, _, let actionItemStatus, _),
                 .imageText(_, _, _, _, let actionItemStatus, _),
                 .video(_, _, let actionItemStatus, _),
                 .videoText(_, _, _, _, let actionItemStatus, _),
                 .reply(_, _, _, let actionItemStatus, _),
                 .pdf(_, _, _, _, _, let actionItemStatus, _),
                 .audio(_, _, let actionItemStatus, _):
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
    

    private var reactionButtonView: some View {
        ZStack {
            Button(action: {
                self.tappedReaction()
            }) {
                ZStack {
                    Image(systemName: "face.smiling") // main icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 17)
                        .foregroundColor(.gray)

                    Image(systemName: "plus.circle.fill") // plus overlay
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.blue)
                        .background(Color.white)
                        .clipShape(Circle())
                        .offset(x: 7, y: 7)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .onLongPressGesture {
                withAnimation {
                    self.tappedReaction()
                }
            }
        }
    }
    
    
    private var reactionListView: some View {
        switch message.messageKind {
        case .text(_, _, _, _, let reactions),
             .image(_, _, _, let reactions),
             .imageText(_, _, _, _, _, let reactions),
             .video(_, _, _, let reactions),
             .videoText(_, _, _, _, _, let reactions),
             .reply(_, _, _, _, let reactions),
             .pdf(_, _, _, _, _, _, let reactions),
             .audio(_, _, _, let reactions):

            if let reactions = reactions, !reactions.isEmpty {
                return AnyView(
                    HStack(spacing: 12) {
                        ForEach(reactions, id: \.emoji) { reaction in
                            HStack(spacing: 4) {
                                Text(reaction.emoji)
                                    .font(.system(size: 12))
                                Text("\(reaction.count)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .shadow(radius: 2)
                )
            }

        default:
            break
        }

        return AnyView(EmptyView())
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
