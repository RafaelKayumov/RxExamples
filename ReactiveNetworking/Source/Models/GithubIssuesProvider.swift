//
//  GithubIssuesProvider.swift
//  ReactiveNetworking
//
//  Created by Rafael Kayumov on 08/06/2020.
//  Copyright © 2020 Rafael Kayumov. All rights reserved.
//

import RxSwift

protocol GithubIssuesProviderProtocol {
    var issuesListOutput: Observable<[Issue]> { get }
}

class GithubIssuesProvider: GithubIssuesProviderProtocol {

    private let repoNameObservable: Observable<String>
    private let apiClient: GithubApiClientProtocol

    init(apiClient: GithubApiClientProtocol, repoName: Observable<String>) {
        self.apiClient = apiClient
        repoNameObservable = repoName
    }

    var issuesListOutput: Observable<[Issue]> {
        repoNameObservable
            .flatMapLatest { [unowned self] query -> Observable<[Issue]?> in
                guard query.isEmpty == false else { return .just([]) }
                return self.apiClient.trackIssues(repoName: query).catchErrorJustReturn([])
            }
            .map { $0 ?? [] }
            .observeOn(MainScheduler.instance)
    }
}
