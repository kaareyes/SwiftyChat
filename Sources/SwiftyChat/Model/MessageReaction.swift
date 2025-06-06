//
//  MessageReaction.swift
//  SwiftyChat
//
//  Created by 1gz on 5/23/25.
//

import Foundation

public class MessageReaction : Codable{
    public var reactionId : String
    public var emoji : String
    public  var imgUrl : String?
    public  var userIdReacted : String

    public init(reactionId: String, emoji: String, imgUrl: String? = nil,userId : String) {
        self.reactionId = reactionId
        self.emoji = emoji
        self.imgUrl = imgUrl
        self.userIdReacted = userId
    }
}

public struct Reaction: Codable {
    public var emoji: String
    public var count: Int
}
