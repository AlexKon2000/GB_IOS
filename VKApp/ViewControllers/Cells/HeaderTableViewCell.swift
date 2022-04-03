//
//  HeaderTableViewCell.swift
//  VKApp
//
//  Created by Alex on 30.03.2022.
//

import UIKit
import Kingfisher
import SnapKit

final class HeaderTableViewCell: UITableViewCell {
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
        userPhoto.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }

        let stackView = UIStackView(arrangedSubviews: [userName, feedCreationDate])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(userPhoto.snp.trailing).offset(8)
            make.top.trailing.bottom.equalToSuperview().inset(8)
        }
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
