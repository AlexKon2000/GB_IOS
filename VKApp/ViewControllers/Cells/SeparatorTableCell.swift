//
//  SeparatorTableCell.swift
//  VKApp
//
//  Created by Alex on 30.03.2022.
//

import UIKit

final class SeparatorTableViewCell: UITableViewCell {
    static let reuseID = String(describing: SeparatorTableViewCell.self)

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
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}
