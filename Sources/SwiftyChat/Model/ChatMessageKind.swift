//
//  MessageKind.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI


public enum ActionItemStatus : String , Codable {
    case pending = "pending"
    case done = "done"
    
    public var body : String {
        switch self {
        case .pending:
            return "Task Pending".uppercased()
        case .done:
            return "TASK DONE".uppercased()
        }
    }
    
    public  var foregroundColor : Color {
        switch self {
        case .pending:
            return Color.yellow
        case .done:
            return Color.blue
        }
    }
    
    public  var logo : String {
        switch  self {
        case .pending:
            return "checkmark.circle"
        case .done:
            return "checkmark.circle"
        }
    }
    
}

public enum SendStatus :String, Codable {
    case sent = "sent"
    case sending = "sending"
    case failed = "failed"
}
public enum MessagePriorityLevel : Int, Codable{
    case critical = 3
    case high = 2
    case medium = 1
    case routine = 0
    case attention = -1
    
    public var body : String {
        switch self {
        case .critical:
            return "Critical Priority"
        case .high:
            return "High Priority"
        case .medium:
            return "Medium Priority"
        default:
            return "Routine"
        }
    }
    
    public  var foregroundColor : Color {
        switch self {
        case . critical:
            return Color.red
        case .high:
            return Color.red
        case .medium:
            return Color.yellow
        default:
            return Color(hex: "3a3b45")

        }
    }
    
    public  var logo : String {
        switch  self {
        case .critical:
            return "waveform.path.ecg.rectangle"
        case .high:
            return "chevron.right.2"
        case .medium:
            return "equal"
        default:
            return "chevron.right.2"

        }
    }
}

public enum ImageLoadingKind {
    case local(UIImage)
    case remote(URL)
}

public enum ChatMessageKind: CustomStringConvertible {
    
    /// A text message,
    /// supports emoji 👍🏻 (auto scales if text is all about emojis) last bool is for followUp
    case text(Bool,Bool,String,[String]?,MessagePriorityLevel,ActionItemStatus?,[MessageReaction]?,Bool)
    
    /// An image message, from local(UIImage) or remote(URL).
    case image(Bool,Bool,ImageLoadingKind,MessagePriorityLevel,ActionItemStatus?,[MessageReaction]?,Bool)
    
    /// An image message, from local(UIImage) or remote(URL).
    case imageText(Bool,Bool,ImageLoadingKind, String,[String]?,MessagePriorityLevel,ActionItemStatus?,[MessageReaction]?,Bool)
    
    /// A location message, pins given location & presents on MapKit.
    case location(LocationItem)
    
    /// A contact message, generally for sharing purpose.
    case contact(ContactItem)
    
    /// Multiple options, disable itself after selection.
    case quickReply([QuickReplyItem])
    
    /// `CarouselItem` contains title, subtitle, image & button in a scrollable view
    case carousel([CarouselItem])
    
    /// A video message, opens the given URL.
    case video(Bool,Bool,VideoItem,MessagePriorityLevel,ActionItemStatus?,[MessageReaction]?,Bool)
    
    case videoText(Bool,Bool,VideoItem,String,[String]?,MessagePriorityLevel,ActionItemStatus?,[MessageReaction]?,Bool)

    /// Loading indicator contained in chat bubble
    case loading
    
    case systemMessage(String)
    
    case reply(Bool,Bool,any ReplyItem,[any ReplyItem],MessagePriorityLevel,ActionItemStatus?,[MessageReaction]?,Bool)
    
    case pdf(Bool,Bool,ImageLoadingKind,String,[String]?,URL,MessagePriorityLevel,ActionItemStatus?,[MessageReaction]?,Bool)
    
    case audio(Bool,Bool,URL,MessagePriorityLevel,ActionItemStatus?,[MessageReaction]?,Bool)
    
    
    public var description: String {
        switch self {
        case .image(let isUrgent, let isAttention, let imageLoadingType, _, _,let reactions,let isFollowup):
            switch imageLoadingType {
            case .local(let localImage):
                return "MessageKind.image(local: \(localImage))"
            case .remote(let remoteImageUrl):
                return "MessageKind.image(remote: \(remoteImageUrl))"
            }
        case .imageText(let isUrgent, let isAttention,let imageLoadingType, let text, _, _, _,let reactions,let isFollowup):
            switch imageLoadingType {
            case .local(let localImage):
                return "MessageKind.imageText(local: \(localImage), text:\(text)"
            case .remote(let remoteImageUrl):
                return "MessageKind.imageText(remote: \(remoteImageUrl), text:\(text))"
            }
        case .text(let isUrgent, let isAttention,let text,let attentions, _, _,let reactions,let isFollowup):
            return "MessageKind.text(\(text) attentions\(attentions))"
        case .location(let location):
            return "MessageKind.location(lat: \(location.latitude), lon: \(location.longitude))"
        case .contact(let contact):
            return "MessageKind.contact(\(contact.displayName))"
        case .quickReply(let quickReplies):
            let options = quickReplies.map { $0.title }.joined(separator: ", ")
            return "MessageKind.quickReplies(options: \(options))"
        case .carousel(let carouselItems):
            return "MessageKind.carousel(itemCount: \(carouselItems.count))"
        case .video(let isUrgent, let isAttention,let videoItem, _, _,let reactions,let isFollowup):
            return "MessageKind.video(url: \(videoItem.url))"
        case .loading:
            return "MessageKind.loading"
        case .systemMessage(let message):
            return "MessageKind.systemMessage \(message)"
        case .videoText(let isUrgent, let isAttention,let videoItem,let text,let attentions, _, _,let reactions,let isFollowup):
            return "MessageKind.video(url: \(videoItem.url) text \(text) tag \(attentions)"
        case . reply(let isUrgent, let isAttention,let reply, let replies, _, _,let reactions,let isFollowup):
            return "MessageKind.reply reply \(reply) and replies \(replies)"
        
        case . pdf(let isUrgent, let isAttention,let image, let text, let attentions,let pdfUrl, _, _,let reactions,let isFollowup):
            switch image {
            case .local(let localImage):
                return "MessageKind.pdf(local: \(localImage), text:\(text), attentions: \(attentions), pdfURL :\(pdfUrl)"
            case .remote(let remoteImageUrl):
                return "MessageKind.pdf(local: \(remoteImageUrl), text:\(text), attentions: \(attentions), pdfURL :\(pdfUrl)"
            }
        case .audio(let isUrgent, let isAttention,let url, _ , _,let reactions,let isFollowup):
            return "MessageKind.audio URL: \(url)"

        }
    }
    
}
