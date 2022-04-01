//
//  PostTableViewCell.swift
//  VKApp
//
//  Created by Alex on 30.03.2022.
//

import UIKit

final class PostTableViewCell: UITableViewCell {
    static let reuseID = String(describing: PostTableViewCell.self)

    private let postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
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
        contentView.addSubview(postLabel)
        postLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        postLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        postLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        postLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }

    func configure(with text: String) {
        postLabel.text = text
    }
}
