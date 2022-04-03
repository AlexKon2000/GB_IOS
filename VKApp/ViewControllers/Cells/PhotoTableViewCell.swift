//
//  PhotoTableViewCell.swift
//  VKApp
//
//  Created by Alex on 30.03.2022.
//

import UIKit
import Kingfisher

final class PhotoTableViewCell: UITableViewCell {
    static let reuseID = String(describing: PhotoTableViewCell.self)

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var heightConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        setupLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayouts() {
        contentView.addSubview(photoImageView)
        photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        heightConstraint = photoImageView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.priority = .defaultHigh
        heightConstraint?.isActive = true
    }

    func configure(with url: URL) {
        photoImageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case let .success(imageResult):
                let ratio = imageResult.image.size.height / imageResult.image.size.width
                self?.heightConstraint?.constant = (self?.photoImageView.bounds.width ?? 0) * ratio
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
