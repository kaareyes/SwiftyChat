//
//  SwiftUIView.swift
//  
//
//  Created by AL Reyes on 2/22/23.
//

import SwiftUI

internal struct ReplyCell<Message: ChatMessage>: View {
    @EnvironmentObject var style: ChatMessageCellStyle
    public let isUrgent: Bool
    public let isAttention: Bool
    public let message: Message
    public let replies : [any ReplyItem]
    public let reply : any ReplyItem
    public let size: CGSize
    public let priority: MessagePriorityLevel
    public let actionStatus: ActionItemStatus?
    public let didTappedMedia: ((String,Message) -> Void)
    public let didTappedViewTask : (Message) -> Void

    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }
    
    private var backgroundColor: Color {
                
       if isUrgent {
           return BubbleColorStyle.urgentColor
        }else if isAttention {
            return BubbleColorStyle.attentionColor
       }
        return cellStyle.cellBackgroundColor
    }
    
    
    var body: some View {
        
        
    LazyVStack(alignment: message.isSender ? .trailing : .leading,spacing: 0) {
        ZStack {
            Group {
                VStack(alignment: message.isSender ? .trailing : .leading,spacing: 0) {
                    ForEach(replies, id: \.id) { item in
                        
                        ReplyItemCell(reply: item, message: message, size: size, priority: priority, didTappedMedia: didTappedMedia)
                            .padding(.bottom)
                            .overlay (
                                VStack {
                                    Spacer()
                                    Divider()
                                        .background(cellStyle.textStyle.textColor)
                                }
                            )
                    }
                    
                    switch reply.fileType {
                    case .video:
                        ImageCell(
                            isUrgent:false,
                            isAttention:false,
                            message: message,
                            imageLoadingType: ImageLoadingKind.remote(URL(string: reply.thumbnailURL!)!),
                            size: size,
                            priority: .attention,
                            actionStatus:nil,
                            didTappedViewTask: {_ in
                                
                            }
                        )
                        .highPriorityGesture(
                            TapGesture()
                                .onEnded {
                                    if let url = reply.fileURL {
                                        self.didTappedMedia(url,message)
                                    }
                                }
                        )
                    case .image:
                        ImageCell(
                            isUrgent:false,
                            isAttention:false,
                            message: message,
                            imageLoadingType: ImageLoadingKind.remote(URL(string: reply.thumbnailURL!)!),
                            size: size,
                            priority: .attention,
                            actionStatus:nil,
                            didTappedViewTask: {_ in
                                
                            }
                        )
                        .highPriorityGesture(
                            TapGesture()
                                .onEnded {
                                    if let url = reply.fileURL {
                                        self.didTappedMedia(url,message)
                                    }
                                }
                        )
                        .padding(.top,10)
                    case .pdf:
                        ImageCell(
                            isUrgent:false,
                            isAttention:false,
                            message: message,
                            imageLoadingType: ImageLoadingKind.remote(URL(string: reply.thumbnailURL!)!),
                            size: size, 
                            priority: .attention,
                            actionStatus:nil,
                            didTappedViewTask: {_ in
                            }
                        )
                        .highPriorityGesture(
                            TapGesture()
                                .onEnded {
                                    if let url = reply.fileURL {
                                        self.didTappedMedia(url,message)
                                    }
                                }
                        )
                        .padding(.top,10)
                    case.text :
                        EmptyView()
                    }
                    if let text = reply.text, text.count > 0{
                        
                        if #available(iOS 15.0, *) {
                            Text(text.phoneAndHtmlAttribute(style: cellStyle.textStyle))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top,10)
                        }else{
                            Text(text.cleanHtml)
                                .fontWeight(cellStyle.textStyle.fontWeight)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(cellStyle.textStyle.textColor)
                                .padding(.top,10)
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

            }
        }
           
            .padding(cellStyle.textPadding)
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

         
        }
    }
}

