//
//  UILabel+Extension.swift
//  VKApp
//
//  Created by Alex on 03.05.2022.
//

import UIKit

extension UILabel {
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!],
            context: nil
        ).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
