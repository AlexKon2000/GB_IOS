//
//  GroupsModel.swift
//  VKApp
//
//  Created by Alex on 14.04.2022.
//

import UIKit
import PromiseKit
import RealmSwift

protocol GroupsModelDelegate: AnyObject {
    func didLoadModel(groups: [Group])
    func didFailLoadModel(with error: Error)
    func notify(changes: (RealmCollectionChange<Results<RealmGroup>>))
}

final class GroupsModel {
    weak var delegate: GroupsModelDelegate?

    private let groupsService = NetworkService<GroupDTO>()
    private var groupToken: NotificationToken?
    private var realmGroupResults: Results<RealmGroup>?

    func load() {
        firstly {
            fetchGroupsFromJSON()
        }.then { groupsDTO in
            self.parseGroups(groupsDTO)
        }.then { realmGroups in
            self.saveAndUpdate(realmGroups)
        }.done { groups in
            self.delegate?.didLoadModel(groups: groups)
        }.catch { error in
            self.delegate?.didFailLoadModel(with: error)
        }
    }

    func observe() {
        groupToken = realmGroupResults?.observe{ [weak self] change in
            self?.delegate?.notify(changes: change)
        }
    }

    func endObserve() {
        groupToken?.invalidate()
    }

    private func fetchGroupsFromJSON() -> Promise<[GroupDTO]> {
        groupsService.path = "/method/groups.get"
        groupsService.queryItems = [
            URLQueryItem(name: "user_id", value: String(SessionStorage.shared.userId)),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "description"),
            URLQueryItem(name: "access_token", value: SessionStorage.shared.token),
            URLQueryItem(name: "v", value: "5.131")
        ]

        return Promise<[GroupDTO]> { seal in
            groupsService.fetch { result in
                switch result {
                case .failure(let error):
                    seal.reject(error)
                case .success(let groupsDTO):
                    seal.fulfill(groupsDTO)
                }
            }
        }
    }

    private func parseGroups(_ groupsDTO: [GroupDTO]) -> Promise<[RealmGroup]> {
        return Promise<[RealmGroup]> { seal in
            let color = CGColor.generateLightColor()
            let realmGroups = groupsDTO.map { RealmGroup(group: $0, color: color) }
            seal.fulfill(realmGroups)
        }
    }

    private func saveAndUpdate(_ realmGroups: [RealmGroup]) -> Promise<[Group]> {
        return Promise<[Group]> { seal in
            do {
                try RealmService.save(items: realmGroups)
                AppDataInfo.shared.groupsUpdateDate = Date()
                let realmUpdateDate = RealmAppInfo(
                    groupsUpdateDate: AppDataInfo.shared.groupsUpdateDate,
                    friendsUpdateDate: AppDataInfo.shared.friendsUpdateDate,
                    feedUpdateDate: AppDataInfo.shared.feedUpdateDate
                )
                try RealmService.save(items: [realmUpdateDate])
                let groups = realmGroups.map {
                    Group(
                        id: $0.id,
                        title: $0.title,
                        imageURL: $0.groupPhotoURL
                    )
                }
                seal.fulfill(groups)
            } catch {
                seal.reject(error)
            }
        }
    }
}
