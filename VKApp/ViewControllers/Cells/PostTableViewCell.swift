//
//  PostTableViewCell.swift
//  VKApp
//
//  Created by Alex on 30.03.2022.
//

import UIKit

final class PostTableViewCell: UITableViewCell {
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
        postLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }

    func configure(with text: String) {
        postLabel.text = text
    }
}
