//
//  File.swift
//  SwiftyChat
//
//  Created by 1gz on 6/3/25.
//

import Foundation


public class ReactionItem : ObservableObject{
   
    @Published var emojis : [Reaction] = []
    init (reactions : [MessageReaction]) {
        for reaction in reactions {
            if let index = emojis.firstIndex(where: {$0.emoji == reaction.emoji}) {
                emojis[index].count = emojis[index].count + 1
            }else{
                emojis.append(Reaction(emoji: reaction.emoji, count: 1))
            }
        }
   }
}
