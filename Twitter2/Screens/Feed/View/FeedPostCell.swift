import SnapKit
import UIKit

protocol FeedPostCellDelegate: AnyObject {
    func didTapDetailsButton(in cell: FeedPostCell)
    func didTapLikeButton(in cell: FeedPostCell)
}

final class FeedPostCell: UITableViewCell {
    weak var delegate: FeedPostCellDelegate?

    private lazy var avatarImageView = makeAvatarImageView()
    private lazy var nameLabel = makeNameLabel()
    private lazy var postTextLabel = makeTextLabel()
    private lazy var detailsButton = makeDetailsButton()
    private lazy var postImageView = makeImageView()
    private lazy var likeButton = makeLikeButton()

    private var post: Post?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func toggleLike() {
        guard let post else {
            return
        }

        likeButton.isSelected.toggle()
        likeButton.backgroundColor = likeButton.isSelected ? .red : .white
        likeButton.setTitle(likeButton.isSelected ? "\(post.likesCount + 1) likes" : "\(post.likesCount) likes", for: .normal)
    }

    func configure(with post: Post) {
        avatarImageView.image = post.avatar
        nameLabel.text = post.name
        postTextLabel.text = post.text
        postImageView.image = post.image
        likeButton.setTitle("\(post.likesCount) likes", for: .normal)
        detailsButton.isHidden = !post.isMine
        self.post = post
    }

    @objc
    private func detailsButtonDidTap() {
        delegate?.didTapDetailsButton(in: self)
    }

    @objc
    private func likeButtonDidTap() {
        delegate?.didTapLikeButton(in: self)
    }

    private func setup() {
        [
            avatarImageView,
            nameLabel,
            postTextLabel,
            detailsButton,
            postImageView,
            likeButton
        ].forEach { contentView.addSubview($0) }
        setupConstraints()
    }

    private func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(36)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
        }
        postTextLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
        }
        detailsButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(20)
        }
        postImageView.snp.makeConstraints { make in
            make.top.equalTo(postTextLabel.snp.bottom).offset(8)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(120)
        }
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(8)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            make.height.equalTo(24)
            make.bottom.equalToSuperview().offset(-12)
        }
    }

    private func makeAvatarImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        return imageView
    }

    private func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }

    private func makeTextLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }

    private func makeDetailsButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(detailsButtonDidTap), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("...", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 28)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }

    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }

    private func makeLikeButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12)
        return button
    }
}
