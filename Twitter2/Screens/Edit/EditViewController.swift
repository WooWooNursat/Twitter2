import UIKit
import SnapKit

final class EditViewController: UIViewController {
    var onPost: (() -> Void)?

    private lazy var postButton = makePostButton()
    private lazy var textView = makeTextView()
    
    private let postsProvider = PostsProvider.shared

    private var postID: Int?
    private var postText: String?

    init(
        postID: Int? = nil,
        text: String? = nil
    ) {
        self.postID = postID
        self.postText = text
        super.init(nibName: nil, bundle:    nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: postButton)
        setup()
        view.backgroundColor = .black
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        textView.becomeFirstResponder()
    }

    @objc
    private func postButtonDidTap() {
        guard let postText else {
            return
        }

        if let postID {
            postsProvider.edit(postText, with: postID)
        } else {
            postsProvider.post(postText)
        }

        onPost?()
    }

    private func setup() {
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    private func makePostButton() -> UIButton {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: .zero, height: 24)))
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(postButtonDidTap), for: .touchUpInside)
        return button
    }

    private func makeTextView() -> UITextView {
        let textView = UITextView()
        textView.delegate = self
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 0.5
        textView.textColor = postText == nil ?  .gray : .white
        textView.text = postText ?? "What's happening?"
        textView.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        return textView
    }
}

extension EditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = postText ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {
            postText = nil
            textView.text = "What's happening?"
            textView.textColor = .gray
            return false
        }

        if isTextEmpty {
            postText = text
            textView.text = text
            textView.textColor = .white
            return false
        }

        postText = updatedText
        return true
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        guard view.window != nil, isTextEmpty else {
            return
        }

        textView.selectedTextRange = textView.textRange(
            from: textView.beginningOfDocument,
            to: textView.beginningOfDocument
        )
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.selectedTextRange = textView.textRange(
            from: textView.beginningOfDocument,
            to: textView.beginningOfDocument
        )
    }

    private var isTextEmpty: Bool {
        postText == nil || postText?.isEmpty == true
    }
}
