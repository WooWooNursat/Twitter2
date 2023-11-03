import UIKit

struct Profile {
    let id: Int = 0
    let avatar = UIImage(named: "avatar")!
    var name = "Nursat"

    static var shared = Profile()
}
