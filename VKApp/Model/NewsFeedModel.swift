//
//  NewsFeedModel.swift
//  VKApp
//
//  Created by Aleksey Kondratev on 04.04.2022.
//

import Foundation

protocol NewsFeedModelDelegate: AnyObject {
    func didLoadModel(feeds: [Feed])
    func didFailLoadModel(with error: Error)
}

final class NewsFeedModel {
    weak var delegate: NewsFeedModelDelegate?

    func load() {
        DispatchQueue.global().async {
            self.fetchData()
        }
    }

    private func fetchData() {
        let feedService = NetworkService<FeedDTO>()

        feedService.path = "/method/newsfeed.get"
        feedService.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "access_token", value: SessionStorage.shared.token),
            URLQueryItem(name: "v", value: "5.131")
        ]

        feedService.fetch { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.didFailLoadModel(with: error)
            case .success(let feedsDTO):
                guard let self = self else {
                    return
                }

                let feeds: [Feed] = feedsDTO.map { feed in
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
                            viewsCount: feed.views.count
                        )
                    } else {
                        if let group = self.loadGroupByID(feed.sourceID) {
                            return Feed(
                                group: group,
                                messageText: feed.text,
                                photos: photosURLs,
                                date: feed.date,
                                likesCount: feed.likes.count,
                                commentsCount: feed.comments.count,
                                viewsCount: feed.views.count
                            )
                        }
                    }
                    return Feed(
                        user: User(
                            id: 0,
                            firstName: "No",
                            secondName: "username",
                            userPhotoURLString: nil
                        ),
                        messageText: feed.text,
                        photos: photosURLs,
                        date: feed.date,
                        likesCount: feed.likes.count,
                        commentsCount: feed.comments.count,
                        viewsCount: feed.views.count
                    )
                }

                let filtered = feeds.filter { $0.messageText != "" }
                DispatchQueue.main.async {
                    self.delegate?.didLoadModel(feeds: filtered)
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
                return Group(
                    id: group.id,
                    title: group.title,
                    imageURL: group.groupPhotoURL
                )
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }

    private func loadPhotosFromFeed(_ feed: FeedDTO) -> [Photo]? {
        guard let images = feed.photosURLs else {
            return nil
        }

        let photos = images.compactMap { $0.photo }
        let photoSizes = photos.map { $0.photos }
        return photoSizes.map { Photo(imageURLString: $0.last?.url) }
    }
}
