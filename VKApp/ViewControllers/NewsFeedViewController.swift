//
//  NewsFeedViewController.swift
//  VKApp
//
//  Created by Alex on 29.03.2022.
//

import UIKit

final class NewsFeedViewController: UIViewController {

    // MARK: - Nested types

    enum CellType {
        case header(userName: String, url: URL?, creationDate: String)
        case post(text: String)
        case photo(url: URL)
        case footer(liks: Int, comments: Int, views: Int)
        case separator
    }

    // MARK: - Properties

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var feeds = [Feed]()
    private var rows = [[CellType]]()
    private let model: NewsFeedModel

    // MARK: - Initializers

    init(with model: NewsFeedModel) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.translatesAutoresizingMaskIntoConstraints = false

        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorStyle = .none

        tableView.register(registerClass: HeaderTableViewCell.self)
        tableView.register(registerClass: PostTableViewCell.self)
        tableView.register(registerClass: PhotoTableViewCell.self)
        tableView.register(registerClass: FooterTableViewCell.self)
        tableView.register(registerClass: SeparatorTableViewCell.self)

        setupLayouts()

        model.delegate = self
        model.load()
    }

    private func setupLayouts() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func fillRows() {
        for feed in feeds {
            var feedRows = [CellType]()

            var userName: String {
                if let user = feed.user?.userName {
                    return user
                } else if let group = feed.group?.title {
                    return group
                } else {
                    return ""
                }
            }

            var url: URL? {
                if let urlString = feed.user?.userPhotoURLString {
                    return URL(string: urlString)
                } else if let groupImageURL = feed.group?.groupPictureURL {
                    return URL(string: groupImageURL)
                } else {
                    return nil
                }
            }

            let creationDate = feed.date.toString(dateFormat: .dateTime)

            feedRows.append(
                .header(
                    userName: userName,
                    url: url,
                    creationDate: creationDate
                )
            )

            if let text = feed.messageText {
                feedRows.append(.post(text: text))
            }

            if let urlString = feed.photos.first?.imageURLString,
               let url = URL(string: urlString)
            {
                feedRows.append(.photo(url: url))
            }

            feedRows.append(
                .footer(
                    liks: feed.likesCount,
                    comments: feed.commentsCount,
                    views: feed.viewsCount
                )
            )

            feedRows.append(.separator)

            rows.append(feedRows)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension NewsFeedViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        feeds.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.section][indexPath.row]

        switch row {
        case let .header(userName, url, creationDate):
            let cell: HeaderTableViewCell = tableView.dequeue(forIndexPath: indexPath)
            cell.configure(
                name: userName,
                url: url,
                creationDate: creationDate
            )
            return cell
        case let .post(text):
            let cell: PostTableViewCell = tableView.dequeue(forIndexPath: indexPath)
            cell.configure(with: text)
            cell.delegate = self
            return cell
        case let .photo(url):
            let cell: PhotoTableViewCell = tableView.dequeue(forIndexPath: indexPath)
            cell.configure(with: url)
            return cell
        case let .footer(likes, comments, views):
            let cell: FooterTableViewCell = tableView.dequeue(forIndexPath: indexPath)
            cell.configure(
                likes: likes,
                comments: comments,
                views: views
            )
            return cell
        case .separator:
            let cell: SeparatorTableViewCell = tableView.dequeue(forIndexPath: indexPath)
            return cell
        }
    }
}

// MARK: - NewsFeedModelDelegate

extension NewsFeedViewController: NewsFeedModelDelegate {
    func didLoadModel(feeds: [Feed]) {
        self.feeds = feeds
        fillRows()
        tableView.reloadData()
    }

    func didFailLoadModel(with error: Error) {
        print(error.localizedDescription)
    }
}

extension NewsFeedViewController: PostExtendable {
    func reload() {
        tableView.performBatchUpdates(nil, completion: nil)
    }
}
