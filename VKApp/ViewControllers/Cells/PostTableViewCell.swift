//
//  PostTableViewCell.swift
//  VKApp
//
//  Created by Alex on 30.03.2022.
//

import UIKit

protocol PostExtendable: AnyObject {
    func reload()
}

final class PostTableViewCell: UITableViewCell {
    weak var delegate: PostExtendable?

    private let postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var showButton: UIButton = {
        let config = UIButton.Configuration.plain()
        let button = UIButton(configuration: config, primaryAction: UIAction { _ in
            self.showButtonTapped()
        })
        button.setTitle("больше", for: .normal)
        return button
    }()

    private var isExpanded = false {
        didSet {
            let title = isExpanded ? "меньше" : "больше"
            showButton.setTitle(title, for: .normal)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        setupLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        isExpanded = false
    }

    private func setupLayouts() {
        contentView.addSubview(postLabel)
        postLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
        }

        contentView.addSubview(showButton)
        showButton.snp.makeConstraints { make in
            make.top.equalTo(postLabel.snp.bottom)
            make.leading.bottom.equalToSuperview().inset(4)
        }
    }

    func configure(with text: String) {
        postLabel.text = text
    }

    private func showButtonTapped() {
        isExpanded = !isExpanded
        postLabel.numberOfLines = isExpanded ? 0 : 1
        delegate?.reload()
    }
}
