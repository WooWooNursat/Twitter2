import UIKit

protocol PostsProviderDelegate: AnyObject {
    func didChangePosts()
}

final class PostsProvider {
    weak var delegate: PostsProviderDelegate?

    static let shared = PostsProvider()

    init() {
        ProfileUpdater.shared.delegate = self
    }

    private var posts: [Post] = [
        .init(
            id: 0,
            authorID: 10,
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
                authorID: Profile.shared.id,
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

extension PostsProvider: ProfileUpdaterDelegate {
    func didUpdateProfile() {
        
        for index in 0..<posts.count {
            if posts[index].authorID == Profile.shared.id {
                posts[index].name = Profile.shared.name
            }
        }
        delegate?.didChangePosts()
    }
}
