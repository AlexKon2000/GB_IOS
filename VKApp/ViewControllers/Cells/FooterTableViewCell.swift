//
//  FooterTableViewCell.swift
//  VKApp
//
//  Created by Alex on 30.03.2022.
//

import UIKit

final class FooterTableViewCell: UITableViewCell {
    static let reuseID = String(describing: FooterTableViewCell.self)

    private lazy var likeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "hand.thumbsup.circle")
        configuration.imagePadding = 4
        let button = UIButton(configuration: configuration, primaryAction: UIAction { _ in
            self.likeButtonTapped()
        })
        return button
    }()

    private lazy var replyButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "message")
        configuration.imagePadding = 4
        let button = UIButton(configuration: configuration, primaryAction: UIAction { _ in
            self.likeButtonTapped()
        })
        return button
    }()

    private lazy var shareButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "arrowshape.turn.up.forward")
        let button = UIButton(configuration: configuration, primaryAction: UIAction { _ in
            self.likeButtonTapped()
        })
        return button
    }()

    private let viewsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.secondaryTextColor
        return label
    }()

    private let eyeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "eye")
        imageView.tintColor = Theme.secondaryTextColor
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        setupLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayouts() {
        let viewsCountStackView = UIStackView(arrangedSubviews: [eyeImageView, viewsCountLabel])
        viewsCountStackView.spacing = 4

        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let stackView = UIStackView(arrangedSubviews: [likeButton, replyButton, shareButton, spacer, viewsCountStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal

        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }

    func configure(
        likes: Int,
        comments: Int,
        views: Int
    ) {
        if likes > 0 {
            likeButton.setTitle("\(likes)", for: .normal)
        }

        if comments > 0 {
            replyButton.setTitle("\(comments)", for: .normal)
        }

        viewsCountLabel.text = "\(views)"
    }

    // MARK: - Actions

    private func likeButtonTapped() {
        // do nothing
    }
}
