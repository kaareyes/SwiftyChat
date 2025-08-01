//
//  BasicInputView.swift
//  
//
//  Created by Enes Karaosman on 19.10.2020.
//

import SwiftUI

public struct BasicInputView: View {
    @Binding private var message: String
    @Binding private var isEditing: Bool
    private let placeholder: String
    
    @State private var contentSizeThatFits: CGSize = .zero
    
    private var internalAttributedMessage: Binding<NSAttributedString> {
        Binding<NSAttributedString>(
            get: {
                createAttributedMessage(from: self.message, with: nil)
            },
            set: { self.message = $0.string }
        )
    }
    
    private func createAttributedMessage(from message: String, with names: [String]?) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: message,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body),
                .foregroundColor: UIColor.label,
            ]
        )
        if let names = names {
            for name in names {
                let pattern = "@\(name)"
                if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                    let range = NSRange(location: 0, length: message.utf16.count)
                    regex.enumerateMatches(in: message, options: [], range: range) { match, _, _ in
                        if let matchRange = match?.range {
                            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: matchRange)
                        }
                    }
                }
            }
        }
        return attributedString
    }

    private var onCommit: ((ChatMessageKind) -> Void)?
    
    public init(
        message: Binding<String>,
        isEditing: Binding<Bool>,
        placeholder: String = "",
        onCommit: @escaping (ChatMessageKind) -> Void
    ) {
        self._message = message
        self.placeholder = placeholder
        self._isEditing = isEditing
        self._contentSizeThatFits = State(initialValue: .zero)
        self.onCommit = onCommit
    }

    private var messageEditorHeight: CGFloat {
        min(
            self.contentSizeThatFits.height,
            0.25 * UIScreen.main.bounds.height
        )
    }

    private var messageEditorView: some View {
        MultilineTextField(
            attributedText: self.internalAttributedMessage,
            placeholder: placeholder,
            isEditing: self.$isEditing,
            onTextViewDidChangeSelection: { textView in
                print(textView.text)
            },
            onTextView: { textView ,range , text in
                
            }
        )
        .onPreferenceChange(ContentSizeThatFitsKey.self) {
            self.contentSizeThatFits = $0
        }
        .frame(height: self.messageEditorHeight)
    }

    private var sendButton: some View {
        Button(action: {
            self.onCommit?(.text(false, false, message,nil, MessagePriorityLevel(rawValue: -1)!, nil,nil))
            self.message.removeAll()
        }, label: {
            Circle().fill(Color(.systemBlue))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .offset(x: -1, y: 1)
                        .padding(8)
                )
        })
        .disabled(message.isEmpty)
    }

    public var body: some View {
        VStack {
            Divider()
            HStack {
                self.messageEditorView
                self.sendButton

            }
        }
    }
    
}
