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

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.translatesAutoresizingMaskIntoConstraints = false

        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorStyle = .none

        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderTableViewCell.reuseID)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.reuseID)
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.reuseID)
        tableView.register(FooterTableViewCell.self, forCellReuseIdentifier: FooterTableViewCell.reuseID)
        tableView.register(SeparatorTableViewCell.self, forCellReuseIdentifier: SeparatorTableViewCell.reuseID)

        setupLayouts()

        fetchFeedsByJSON()
    }

    private func setupLayouts() {
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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

    private func fetchFeedsByJSON() {

        let feedService = NetworkService<FeedDTO>()

        feedService.path = "/method/newsfeed.get"
        feedService.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "access_token", value: SessionStorage.shared.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        feedService.fetch { [weak self] feedDTOObjects in
            switch feedDTOObjects {
            case .failure(let error):
                print(error)
            case .success(let feedsDTO):
                guard let self = self else { return }
                self.feeds = feedsDTO.map { feed in

                    let photosURLs = self.loadPhotosFromFeed(feed)

                    if feed.sourceID > 0,
                       let user = self.loadUserByID(feed.sourceID) {
                        return Feed(
                            user: user,
                            messageText: feed.text,
                            photos: photosURLs,
                            date: feed.date,
                            likesCount: feed.likes.count,
                            commentsCount: feed.comments.count,
                            viewsCount: feed.views.count)
                    } else {
                        if let group = self.loadGroupByID(feed.sourceID) {
                            return Feed(
                                group: group,
                                messageText: feed.text,
                                photos: photosURLs,
                                date: feed.date,
                                likesCount: feed.likes.count,
                                commentsCount: feed.comments.count,
                                viewsCount: feed.views.count)
                        }
                    }
                    return Feed(
                        user: User(id: 0, firstName: "No", secondName: "username", userPhotoURLString: nil),
                        messageText: feed.text,
                        photos: photosURLs,
                        date: feed.date,
                        likesCount: feed.likes.count,
                        commentsCount: feed.comments.count,
                        viewsCount: feed.views.count
                    )
                }
                self.feeds = self.feeds.filter{ $0.messageText != "" }
                DispatchQueue.main.async {
                    self.fillRows()
                    self.tableView.reloadData()
                }
            }
        }
    }

    private func loadUserByID(_ id: Int) -> User? {
        do {
            let realmUsers: [RealmUser] = try RealmService.load(typeOf: RealmUser.self)
            if let user = realmUsers.filter({ $0.id == id }).first {
                return User(
                    id: user.id,
                    firstName: user.firstName,
                    secondName: user.secondName,
                    userPhotoURLString: user.userPhotoURLString
                )
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }

    private func loadGroupByID(_ id: Int) -> Group? {
        do {
            let realmGroups: [RealmGroup] = try RealmService.load(typeOf: RealmGroup.self)
            if let group = realmGroups.filter({ $0.id == -id }).first {
                return Group(id: group.id, title: group.title, imageURL: group.groupPhotoURL)
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }

    private func loadPhotosFromFeed(_ feed: FeedDTO) -> [Photo]? {
        guard let images = feed.photosURLs else { return nil }
        let photos = images.compactMap { $0.photo }
        let photoSizes = photos.map { $0.photos }
        return photoSizes.map { Photo(imageURLString: $0.last?.url) }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.reuseID, for: indexPath) as! HeaderTableViewCell
            cell.configure(
                name: userName,
                url: url,
                creationDate: creationDate
            )
            return cell
        case let .post(text):
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseID, for: indexPath) as! PostTableViewCell
            cell.configure(with: text)
            return cell
        case let .photo(url):
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.reuseID, for: indexPath) as! PhotoTableViewCell
            cell.configure(with: url)
            return cell
        case let .footer(likes, comments, views):
            let cell = tableView.dequeueReusableCell(withIdentifier: FooterTableViewCell.reuseID, for: indexPath) as! FooterTableViewCell
            cell.configure(
                likes: likes,
                comments: comments,
                views: views
            )
            return cell
        case .separator:
            return tableView.dequeueReusableCell(withIdentifier: SeparatorTableViewCell.reuseID, for: indexPath) as! SeparatorTableViewCell
        }
    }
}
