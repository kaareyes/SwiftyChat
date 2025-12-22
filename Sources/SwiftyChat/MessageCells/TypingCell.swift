//
//  File.swift
//  SwiftyChat
//
//  Created by 1gz on 12/22/25.
//

import Foundation
import SwiftUI

internal struct TypingCell<Message: ChatMessage>: View {
    @EnvironmentObject var style: ChatMessageCellStyle
    public let message: Message


    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }
    var body: some View {
        
        HStack {
            TypingDotsView()
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
        }
        //.frame(width: width)
        .background(cellStyle.cellBackgroundColor)
        .clipShape(RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners))
        .overlay(
            
            RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners)
            .stroke(
                cellStyle.cellBorderColor,
                lineWidth: cellStyle.cellBorderWidth  * 0.8
            )
            .shadow(
                color: cellStyle.cellShadowColor,
                radius: cellStyle.cellShadowRadius
            )
        )

    }
}

internal struct TypingDotsView: View {
    @State private var animate = false

    private let dotSize: CGFloat = 6
    private let dotSpacing: CGFloat = 5

    var body: some View {
        HStack(spacing: dotSpacing) {
            dot(delay: 0.0)
            dot(delay: 0.15)
            dot(delay: 0.30)
        }
        .onAppear {
            // Avoid restarting repeatedly if the cell reappears in lists
            guard !animate else { return }
            animate = true
        }
    }

    private func dot(delay: Double) -> some View {
        Circle()
            .frame(width: dotSize, height: dotSize)
            .opacity(animate ? 1.0 : 0.35)
            .scaleEffect(animate ? 1.0 : 0.6)
            .animation(
                Animation
                    .easeInOut(duration: 0.6)
                    .repeatForever(autoreverses: true)
                    .delay(delay),
                value: animate
            )
    }
}
