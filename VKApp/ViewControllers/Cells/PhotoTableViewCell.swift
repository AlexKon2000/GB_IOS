//
//  PhotoTableViewCell.swift
//  VKApp
//
//  Created by Alex on 30.03.2022.
//

import UIKit
import Kingfisher
import SnapKit

final class PhotoTableViewCell: UITableViewCell {
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var heightConstraint: Constraint?

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
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
            heightConstraint = make.height.equalTo(0).priority(.high).constraint
        }
    }

    func configure(with url: URL) {
        photoImageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case let .success(imageResult):
                let ratio = imageResult.image.size.height / imageResult.image.size.width
                let height = (self?.photoImageView.bounds.width ?? 0) * ratio
                self?.heightConstraint?.update(offset: height)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
