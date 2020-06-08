//
//  Endpoints.swift
//  ReactiveNetworking
//
//  Created by Rafael Kayumov on 08/06/2020.
//  Copyright © 2020 Rafael Kayumov. All rights reserved.
//

import Foundation

protocol GithubEndpointProtocol {
    var request: URLRequest { get }
}

enum GithubEndpoint {

    private static let baseURL = URL(string: "https://api.github.com")!

    case repository(_ repoName: String)
    case issues(_ repoName: String)

    private var path: String {
        switch self {
        case .repository(let repoName):
            return "/repos/\(repoName)"
        case .issues(let repoName):
            return "/repos/\(repoName)/issues"
        }
    }

    private var httpMethod: String {
        switch self {
        case .repository, .issues:
            return "GET"
        }
    }
}

extension GithubEndpoint: GithubEndpointProtocol {

    internal var request: URLRequest {
        let url = GithubEndpoint.baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}

