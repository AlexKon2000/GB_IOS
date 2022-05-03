//
//  ResponseDTO.swift
//  VKApp
//
//  Created by Alla Shkolnik on 15.02.2022.
//

import Foundation

struct ItemsDTO<ItemsType: Decodable> {
    let items: [ItemsType]
    let count: Int?
    let nextFrom: String?
}

extension ItemsDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case items
        case count
        case nextFrom = "next_from"
    }
}
