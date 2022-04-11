//
//  SaveDataOperation.swift
//  VKApp
//
//  Created by Aleksey Kondratev on 11.04.2022.
//

import UIKit

class SaveDataOperation: Operation {
    var outputData: [RealmUser]? = []

    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
              let data = getDataOperation.data else {
            return
        }

        let color = CGColor.generateLightColor()
        let realmUsers = data.map { RealmUser(user: $0, color: color) }
            .filter { $0.deactivated == nil }

        do {
            try RealmService.save(items: realmUsers)
            AppDataInfo.shared.friendsUpdateDate = Date()

            let realmUpdateDate = RealmAppInfo(
                groupsUpdateDate: AppDataInfo.shared.groupsUpdateDate,
                friendsUpdateDate: AppDataInfo.shared.friendsUpdateDate,
                feedUpdateDate: AppDataInfo.shared.feedUpdateDate
            )
            try RealmService.save(items: [realmUpdateDate])
            outputData = realmUsers
        } catch {
            print(error)
        }
    }
}
