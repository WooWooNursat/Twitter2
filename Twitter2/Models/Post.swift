import UIKit

struct Post {
    let id: Int
    let authorID: Int
    let avatar: UIImage
    var name: String
    var text: String
    let uploadDate: Date
    let image: UIImage?
    var likesCount: Int
    let isMine: Bool
    var isLiked: Bool
}
