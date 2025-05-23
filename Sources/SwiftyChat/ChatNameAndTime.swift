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
                    timeStamp
                    actionStatus
                    reactionButtonView
                        .padding(.leading,2)
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
                        case .text(_, _,  _, let actionItemStatus):
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

                        case .image(_, _, let actionItemStatus):
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
                        case .imageText(_, _, _, _, let actionItemStatus):
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
                        case .video(_, _, let actionItemStatus):
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
                        case .videoText(_, _, _, _, let actionItemStatus):
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
                        case .reply(_, _, _, let actionItemStatus):
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
                        case .pdf(_, _, _, _, _, let actionItemStatus):
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
                        case .audio(_, _, let actionItemStatus):
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
    
    private var actionStatus : some View {
        HStack(spacing : 5) {
            
            if !message.isSender {
                currentUser
            }
            switch message.messageKind {
            case .text(_, _,  _, let actionItemStatus):
                if let actionItemStatus = actionItemStatus {
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
                    EmptyView()
                }

            case .image(_, _, let actionItemStatus):
                if let actionItemStatus = actionItemStatus {
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
                    EmptyView()
                }
            case .imageText(_, _, _, _, let actionItemStatus):
                if let actionItemStatus = actionItemStatus {
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
                    EmptyView()
                }
            case .video(_, _, let actionItemStatus):
                if let actionItemStatus = actionItemStatus {
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
                    EmptyView()
                }
            case .videoText(_, _, _, _, let actionItemStatus):
                if let actionItemStatus = actionItemStatus {
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
                    EmptyView()
                }
            case .reply(_, _, _, let actionItemStatus):
                if let actionItemStatus = actionItemStatus {
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
                    EmptyView()
                }
            case .pdf(_, _, _, _, _, let actionItemStatus):
                if let actionItemStatus = actionItemStatus {
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
                    EmptyView()
                }
            case .audio(_, _, let actionItemStatus):
                if let actionItemStatus = actionItemStatus {
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
    
    
}
