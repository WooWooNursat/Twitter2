import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    var onFinish: (() -> Void)?

    private lazy var avatarImageView = {
        let imageView = UIImageView(image: profile.avatar)
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameTextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.text = profile.name
        textField.placeholder = "Enter your name"
        textField.tintColor = .gray
        return textField
    }()

    private lazy var postButton = makePostButton()

    private let profile = Profile.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: postButton)
        view.backgroundColor = .black
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        nameTextField.becomeFirstResponder()
    }

    @objc
    private func postButtonDidTap() {
        guard let text = nameTextField.text, !text.isEmpty else {
            return
        }

        Profile.shared.name = text
        ProfileUpdater.shared.notify()
        onFinish?()
    }

    private func setup() {
        [avatarImageView, nameTextField].forEach { view.addSubview($0) }
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(40)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(240)
            make.height.equalTo(24)
        }
    }

    private func makePostButton() -> UIButton {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: .zero, height: 24)))
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(postButtonDidTap), for: .touchUpInside)
        return button
    }
}
