//
//  SeparatorTableCell.swift
//  VKApp
//
//  Created by Alex on 30.03.2022.
//

import UIKit

final class SeparatorTableViewCell: UITableViewCell {
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        selectionStyle = .none
        backgroundColor = .clear

        separator.backgroundColor = .systemGray5

        contentView.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
    }
}
