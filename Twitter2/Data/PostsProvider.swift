import UIKit

protocol PostsProviderDelegate: AnyObject {
    func didChangePosts()
}

final class PostsProvider {
    weak var delegate: PostsProviderDelegate?

    static let shared = PostsProvider()

    private var posts: [Post] = [
        .init(
            id: 0,
            avatar: UIImage(named: "avatar")!,
            name: "Tengrinews",
            text: "Макрон опубликовал твит на казахском языке",
            uploadDate: Date(),
            image: UIImage(named: "post-image")!,
            likesCount: 3,
            isMine: false,
            isLiked: false
        )
    ]

    func getPosts() -> [Post] {
        posts
    }

    func togglePostLike(with id: Int) {
        guard let postIndex = posts.firstIndex(where: { $0.id == id }) else {
            return
        }

        posts[postIndex].isLiked.toggle()
        posts[postIndex].likesCount += (posts[postIndex].isLiked ? 1 : -1)
    }

    func deletePost(with id: Int) {
        guard let postIndex = posts.firstIndex(where: { $0.id == id }) else {
            return
        }

        posts.remove(at: postIndex)
        delegate?.didChangePosts()
    }

    func post(_ text: String) {
        posts.append(
            Post(
                id: posts.count,
                avatar: Profile.shared.avatar,
                name: Profile.shared.name,
                text: text,
                uploadDate: Date(),
                image: nil,
                likesCount: 0,
                isMine: true,
                isLiked: false
            )
        )
        delegate?.didChangePosts()
    }

    func edit(_ text: String, with id: Int) {
        guard let postIndex = posts.firstIndex(where: { $0.id == id }) else {
            return
        }

        posts[postIndex].text = text
        delegate?.didChangePosts()
    }
}
