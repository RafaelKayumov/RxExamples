//
//  Repository.swift
//  ReactiveNetworking
//
//  Created by Rafael Kayumov on 08/06/2020.
//  Copyright © 2020 Rafael Kayumov. All rights reserved.
//

import Foundation

struct Repository: Decodable {

    let identifier: Int
    let language: String
    let name: String
    let fullName: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id"

        case language
        case name
        case fullName
    }
}
