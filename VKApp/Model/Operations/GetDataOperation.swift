//
//  GetDataOperation.swift
//  VKApp
//
//  Created by Aleksey Kondratev on 11.04.2022.
//

import Foundation

final class GetDataOperation: AsyncOperation {
    var data: [UserDTO]? = []

    override func main() {
        let friendsService = NetworkService<UserDTO>()
        friendsService.path = "/method/friends.get"
        friendsService.queryItems = [
            URLQueryItem(name: "user_id", value: String(SessionStorage.shared.userId)),
            URLQueryItem(name: "order", value: "name"),
            URLQueryItem(name: "fields", value: "photo_50"),
            URLQueryItem(name: "access_token", value: SessionStorage.shared.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        friendsService.fetch { [weak self] friendsDTOObjects in
            switch friendsDTOObjects {
            case .failure(let error):
                print(error)
            case .success(let friendsDTO):
                self?.data = friendsDTO
            }
            self?.state = .finished
        }
    }
}
