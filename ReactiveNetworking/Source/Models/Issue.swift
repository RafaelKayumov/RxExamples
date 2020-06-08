//
//  Issue.swift
//  ReactiveNetworking
//
//  Created by Rafael Kayumov on 08/06/2020.
//  Copyright © 2020 Rafael Kayumov. All rights reserved.
//

import Foundation

struct Issue: Decodable {

    let identifier: Int
    let number: Int
    let title: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id"

        case number
        case title
        case body
    }
}
