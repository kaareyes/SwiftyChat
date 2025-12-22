//
//  Untitled.swift
//  SwiftyChat
//
//  Created by 1gz on 12/22/25.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil

    private let url: URL?
    private static let cache = NSCache<NSURL, UIImage>()

    init(url: URL?) {
        self.url = url
        load()
    }

    private func load() {
        guard let url = url else { return }

        if let cached = Self.cache.object(forKey: url as NSURL) {
            self.image = cached
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let img = UIImage(data: data) else { return }
            Self.cache.setObject(img, forKey: url as NSURL)
            DispatchQueue.main.async {
                self.image = img
            }
        }.resume()
    }
}

public struct SeenAvatarsView: View {


    let users: [SeenAvatarUser]
    var maxVisible: Int = 4
    var size: CGFloat = 14
    var spacing: CGFloat = 7   // spacing between avatars (max 7, no overlap)
    var showPlusFirst: Bool = true

    private var extraCount: Int { max(0, users.count - maxVisible) }
    private var visibleUsers: [SeenAvatarUser] { Array(users.suffix(min(users.count, maxVisible))) }

    public var body: some View {
        HStack(spacing: min(spacing, 5)) {
            if extraCount > 0, showPlusFirst {
                plusBubble("+\(extraCount)")
            }

            ForEach(visibleUsers) { user in
                avatar(user.imageUrl)
            }
        }
        .frame(height: size)
    }

    private func avatar(_ url: URL?) -> some View {
        AvatarImageView(url: url, size: size)
    }

    private func plusBubble(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .frame(height: size)
            .background(Color.black.opacity(0.35))
            .clipShape(Capsule())
    }
}

struct AvatarImageView: View {
    let url: URL?
    let size: CGFloat

    @StateObject private var loader: ImageLoader

    init(url: URL?, size: CGFloat) {
        self.url = url
        self.size = size
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.black.opacity(0.25), lineWidth: 1))
    }
}
