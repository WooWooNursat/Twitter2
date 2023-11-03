import UIKit
import SnapKit

final class FeedViewController: UIViewController {
    var onPlusButtonTap: (() -> Void)?
    var onEdit: ((_ id: Int, _ text: String) -> Void)?
    var onAvatar: (() -> Void)?

    private lazy var tableView = makeTableView()
    private lazy var plusButton = makePlusButton()
    private lazy var avatarButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: .init(width: 24, height: 24)))
        button.contentMode = .scaleAspectFill
        button.setImage(Profile.shared.avatar, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(avatarDidTap), for: .touchUpInside)
        return button
    }()

    private var posts: [Post] = []

    private let postsProvider = PostsProvider.shared

    override func loadView() {
        super.loadView()

        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        getPosts()
        let barButton = UIBarButtonItem(customView: avatarButton)
        navigationItem.leftBarButtonItem = barButton
    }

    @objc
    private func plusButtonDidTap() {
        onPlusButtonTap?()
    }

    @objc
    private func avatarDidTap() {
        onAvatar?()
    }

    private func getPosts() {
        posts = postsProvider.getPosts()
        print("DEBUG: posts \(posts.count)")
        tableView.reloadData()
    }

    private func setupView() {
        [tableView, plusButton].forEach { view.addSubview($0) }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        plusButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.size.equalTo(40)
        }
        avatarButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        postsProvider.delegate = self
    }

    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.alwaysBounceVertical = true
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        [
            FeedPostCell.self
        ].forEach { tableView.register(cellClass: $0) }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }

    private func makePlusButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 28)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(plusButtonDidTap), for: .touchUpInside)
        return button
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(FeedPostCell.self, for: indexPath)
        cell.configure(with: posts[indexPath.row])
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FeedPostCell else {
            return
        }

        cell.delegate = self
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FeedViewController: FeedPostCellDelegate {
    func didTapDetailsButton(in cell: FeedPostCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        presentDetailsSheet(for: posts[indexPath.row])
    }

    func didTapLikeButton(in cell: FeedPostCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        cell.toggleLike()
        posts[indexPath.row].isLiked.toggle()
        postsProvider.togglePostLike(with: posts[indexPath.row].id)
    }

    private func presentDetailsSheet(for post: Post) {
        let controller = UIAlertController(
            title: "Details", 
            message: nil,
            preferredStyle: .actionSheet
        )
        controller.addAction(
            UIAlertAction(
                title: "Edit",
                style: .default
            ) { [weak self] _ in
                self?.onEdit?(post.id, post.text)
            }
        )
        controller.addAction(
            UIAlertAction(
                title: "Delete",
                style: .destructive
            ) { [weak self] _ in
                self?.postsProvider.deletePost(with: post.id)
            }
        )
        controller.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        present(controller, animated: true)
    }
}

extension FeedViewController: PostsProviderDelegate {
    func didChangePosts() {
        getPosts()
    }
}
