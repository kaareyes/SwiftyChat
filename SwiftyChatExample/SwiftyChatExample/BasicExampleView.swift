//
//  BasicExampleView.swift
//  SwiftyChatExample
//
//  Created by Enes Karaosman on 21.10.2020.
//

import SwiftUI
import SwiftyChat

public struct Reply : ReplyItem {
    public var id: UUID = UUID()
    public var fileType: ReplyItemKind
    public var displayName: String
    public var thumbnailURL: String?
    public var fileURL: String?
    public var text: String?
    public var date: String
    
    init(fileType : ReplyItemKind,displayName : String,thumbnailURL : String?,fileURL: String?, text :String?, date: String ){
        self.fileURL = fileURL
        self.fileType = fileType
        self.displayName = displayName
        self.thumbnailURL = thumbnailURL
        self.fileURL = fileURL
        self.text = text
        self.date = date
    }
    
}
struct BasicExampleView: View {
    
    @State var messages: [MockMessages.ChatMessageItem] = [] //MockMessages.generateMessage(kind: .Text, count: 0)
    
    // MARK: - InputBarView variables
    @State private var message = ""
    @State private var isEditing = false
    @State private var showingOptions = false

    var body: some View {
        chatView
            .onAppear {
//                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("<p>Amigo Reyes</p>", ["Jett Calleja","Juan Carlos","amigo Reyes"], .attention, nil), messageUUID: UUID().uuidString))
//                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("New task(s) are assigned to you on action items. \n Note: Operation Singil: si ocs", ["Jett Calleja"], .attention, .pending), messageUUID: UUID().uuidString))
////                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("New task(s) are assigned to you on action items. \n Note: Operation Singil: si ocs", ["Jett Calleja"], .medium, .pending), messageUUID: UUID().uuidString))
////                
////                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("New task(s) are assigned to you on action items. \n Note: Operation Singil: si ocs", ["Jett Calleja"], .high, .pending), messageUUID: UUID().uuidString))
////                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("<p>Hello Doc,<br>Good Morning.<br>Please see attached file for patient's lab report.<br>Let me know if you have any order/s.<br>Thank you.&nbsp;</p>\n<p></p>\n<p>BMP <br>glucose: 167<br>bun: 31<br>egfr: 52<br>bun/crea ratio: 29<br>sodium: 135<br>chloride: 96<br></p>", ["Jett Calleja"], .high, .pending), messageUUID: UUID().uuidString))
////                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("<pr><b>BOLD</b><b><i>BOLD ITALIC</i></b></pr><p>Hello Doc,<br>Good Morning.<br>Please see attached file for patient's lab report.<br>Let me know if you have any order/s.<br>Thank you.&nbsp;</p>\n<p></p>\n<p>BMP <br>glucose: 167<br>bun: 31<br>egfr: 52<br>bun/crea ratio: 29<br>sodium: 135<br>chloride: 96<br></p>", nil, .high, .pending), messageUUID: UUID().uuidString))
////                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("Hello world", nil, .high, .pending), messageUUID: UUID().uuidString))
////
////                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("6/2/24 -- telemed\n\nGullet, Clark\n\nMr. Clark gullet with redness noted to right arm. no c/o pain\nNo fever\nVitals wnl\n\nPE: scaly rashes on dorsal right hand w/ surrounding redness of hand\nno open wound\n\n\u{FFFC}\n\nA\u{2028}Cellulitis-Right hand\nTinea corporis\n\nP\nKeflex 500 mgs q6 X 7 days.\nLotrisone 1% cream BID X 2 weeks\n-----\n99307", nil, .routine, nil), messageUUID: UUID().uuidString))
////
////                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .imageText(.remote(URL(string: "https://medchat.s3.amazonaws.com/23fe9b65-baef-4853-b0ed-66e064d10931IMG_2584_thumb.jpg")!), "6/2/24 -- telemed\n\nGullet, Clark\n\nMr. Clark gullet with redness noted to right arm. no c/o pain\nNo fever\nVitals wnl\n\nPE: scaly rashes on dorsal right hand w/ surrounding redness of hand\nno open wound\n\n\u{FFFC}\n\nA\u{2028}Cellulitis-Right hand\nTinea corporis\n\nP\nKeflex 500 mgs q6 X 7 days.\nLotrisone 1% cream BID X 2 weeks\n-----\n99307", nil, .routine, nil), messageUUID: UUID().uuidString))
                
            }
    }
    
    private var chatView: some View {
        
        ChatView<MockMessages.ChatMessageItem, MockMessages.ChatUserItem>(inverted : true , messages: $messages) {
            
            BasicInputView(
                message: $message,
                isEditing: $isEditing,
                placeholder: "Type something",
                onCommit: { messageKind in
                    self.messages.append(
                        .init(user: MockMessages.chatbot, messageKind: messageKind, isSender: true,
                              messageUUID: UUID().uuidString)
                    )
                }
            )
            .padding(8)
            .padding(.bottom, isEditing ? 0 : 8)
            .accentColor(.chatBlue)
            .background(Color.primary.colorInvert())
            .animation(.linear)
            .embedInAnyView()
            
        }reachedTop: { lastDate in
            print("Top cell \(lastDate)")
        }reachedBottom: { lastDate in
            print("Bottom cell \(lastDate)")
        }tappedResendAction: { message in
            print("resend tapped message ",message.messageKind.description)
        
        }didDismissKeyboard: {
            
        }
        .didTappedViewTask({ message in
            print("didtapped view task \(message.messageKind)")
        })
        .onMessageCellLongpressed({ message in
            print(  message.messageKind.description)
            self.showingOptions = true
        })
        
            
        
        .actionSheet(isPresented: $showingOptions) {
            ActionSheet(
                title: Text("Food alert!"),
                message: Text("You have made a selection"),
                buttons: [
                    .cancel(),
                    .destructive(Text("Change to 🍑")) { /* override */ },
                    .default(Text("Confirm")) { /* confirm */ }
                ]
            )
        }

        // ▼ Required
        .environmentObject(ChatMessageCellStyle.basicStyle)
        .navigationBarTitle("Basic")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(PlainListStyle())
    }
}

struct BasicExampleView_Previews: PreviewProvider {
    static var previews: some View {
        BasicExampleView()
    }
}
struct TestVideo: VideoItem {
    var url: URL
    var placeholderImage: ImageLoadingKind
    var pictureInPicturePlayingMessage: String
}
