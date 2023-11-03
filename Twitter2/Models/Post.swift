import UIKit

struct Post {
    let id: Int
    let avatar: UIImage
    let name: String
    var text: String
    let uploadDate: Date
    let image: UIImage?
    var likesCount: Int
    let isMine: Bool
    var isLiked: Bool
}
