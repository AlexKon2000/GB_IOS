//
//  FriendsModel.swift
//  VKApp
//
//  Created by Aleksey Kondratev on 11.04.2022.
//

import UIKit
import RealmSwift

protocol FriendsModelDelegate: AnyObject {
    func didLoadModel(friends: [User])
    func didFailLoadModel(with error: Error)
    func notify(changes: (RealmCollectionChange<Results<RealmUser>>))
}

final class FriendsModel {
    weak var delegate: FriendsModelDelegate?

    private let friendsService = NetworkService<UserDTO>()
    private var realmFriendResults: Results<RealmUser>?
    private var friendsToken: NotificationToken?

    var friends: [User] = [] {
        didSet {
            self.delegate?.didLoadModel(friends: self.friends)
        }
    }

    func observe() {
        friendsToken = realmFriendResults?.observe{ [weak self] change in
            self?.delegate?.notify(changes: change)
        }
    }

    func endObserve() {
        friendsToken?.invalidate()
    }

    func load() {
        let operationQueue = OperationQueue()
        let getDataOperation = GetDataOperation()
        operationQueue.addOperation(getDataOperation)

        let saveDataOperation = SaveDataOperation()
        saveDataOperation.addDependency(getDataOperation)
        OperationQueue.main.addOperation(saveDataOperation)

        let updateDataOperation = UpdateDataOperation(with: self)
        updateDataOperation.addDependency(saveDataOperation)
        OperationQueue.main.addOperation(updateDataOperation)
    }
}
