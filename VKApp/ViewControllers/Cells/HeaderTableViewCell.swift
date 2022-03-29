//
//  HeaderTableViewCell.swift
//  VKApp
//
//  Created by Alex on 30.03.2022.
//

import UIKit
import Kingfisher

final class HeaderTableViewCell: UITableViewCell {
    static let reuseID = String(describing: HeaderTableViewCell.self)

    private let userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let userName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = Theme.mainTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()

    private let feedCreationDate: UILabel = {
        let label = UILabel()
        label.textColor = Theme.secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
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
        contentView.addSubview(userPhoto)
        userPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        userPhoto.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        userPhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        userPhoto.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        userPhoto.widthAnchor.constraint(equalToConstant: 40).isActive = true
        userPhoto.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let stackView = UIStackView(arrangedSubviews: [userName, feedCreationDate])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical

        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: userPhoto.trailingAnchor, constant: 8).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }

    func configure(
        name: String,
        url: URL?,
        creationDate: String
    ) {
        userName.text = name

        if let url = url {
            userPhoto.kf.setImage(with: url)
        }

        feedCreationDate.text = creationDate
    }
}
