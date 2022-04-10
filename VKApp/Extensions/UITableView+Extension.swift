//
//  UITableView+Extension.swift
//  VKApp
//
//  Created by Alex on 01.04.2022.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(registerClass: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }

    func register<T: UITableViewHeaderFooterView>(registerClass: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }

    func dequeue<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    func dequeue<T: UITableViewHeaderFooterView>() -> T {
        dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as! T
    }
}
