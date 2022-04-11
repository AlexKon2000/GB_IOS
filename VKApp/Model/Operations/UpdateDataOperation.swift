//
//  UpdateDataOperation.swift
//  VKApp
//
//  Created by Aleksey Kondratev on 11.04.2022.
//

import Foundation

final class UpdateDataOperation: Operation {
    let model: FriendsModel

    init(with model: FriendsModel) {
        self.model = model
    }

    override func main() {
        guard let savedData = dependencies.first as? SaveDataOperation,
              let data = savedData.outputData else {
            return
        }

        let friends = data.map { realmFriend in
            User(
                id: realmFriend.id,
                firstName: realmFriend.firstName,
                secondName: realmFriend.secondName,
                userPhotoURLString: realmFriend.userPhotoURLString
            )
        }

        model.friends = friends
    }
}
