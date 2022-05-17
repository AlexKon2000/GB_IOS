//
//  PostTableViewCell.swift
//  VKApp
//
//  Created by Alex on 30.03.2022.
//

import UIKit
import SnapKit

protocol PostExtendable: AnyObject {
    func reload(indexPath: IndexPath)
}

final class PostTableViewCell: UITableViewCell {
    weak var delegate: PostExtendable?

    private let postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Constants.initialNumberOfLines
        label.backgroundColor = Theme.backgroundColor
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

    private var indexPath: IndexPath?

    var isExpanded = false {
        didSet {
            let title = isExpanded ? "меньше" : "больше"
            showButton.setTitle(title, for: .normal)
            postLabel.numberOfLines = isExpanded ? 0 : Constants.initialNumberOfLines
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

    override func layoutSubviews() {
        super.layoutSubviews()

        showButton.isHidden = postLabel.maxNumberOfLines <= Constants.initialNumberOfLines
    }

    private func setupLayouts() {
        contentView.addSubview(postLabel)
        postLabel.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview().inset(8)
        }

        contentView.addSubview(showButton)
        showButton.snp.makeConstraints { make in
            make.top.equalTo(postLabel.snp.bottom)
            make.leading.bottom.equalToSuperview().inset(8)
        }
    }

    func configure(with text: String, indexPath: IndexPath) {
        postLabel.text = text
        self.indexPath = indexPath
    }

    @objc private func showButtonTapped() {
        guard let indexPath = indexPath else {
            return
        }

        delegate?.reload(indexPath: indexPath)
    }
}

private enum Constants {
    static let initialNumberOfLines = 2
}
