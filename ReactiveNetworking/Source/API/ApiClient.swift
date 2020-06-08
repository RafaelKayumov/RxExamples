//
//  ApiClient.swift
//  ReactiveNetworking
//
//  Created by Rafael Kayumov on 08/06/2020.
//  Copyright © 2020 Rafael Kayumov. All rights reserved.
//

import RxSwift
import RxCocoa

protocol GithubApiClientProtocol {

    func trackIssues(repoName: String) -> Observable<[Issue]?>
}

class ApiClient {

    private let networking: NetworkingProtocol

    init(networking: NetworkingProtocol) {
        self.networking = networking
    }
}

extension ApiClient: GithubApiClientProtocol {

    func trackIssues(repoName: String) -> Observable<[Issue]?> {
        return get(repoWithName: repoName)
            .flatMap { [unowned self] repo -> Observable<[Issue]?> in
                guard
                    let repoName = repo?.fullName,
                    repoName.isEmpty == false
                else { return Observable.just(nil) }
                return self.get(issuesForRepo: repoName)
        }
    }

    func get(repoWithName repoName: String) -> Observable<Repository?> {
        let endpoint = GithubEndpoint.repository(repoName)
        return networking.request(endpoint.request)
            .flatMap { [unowned self] in self.decode($0) }
    }

    func get(issuesForRepo repoName: String) -> Observable<[Issue]?> {
        let endpoint = GithubEndpoint.issues(repoName)
        return networking.request(endpoint.request)
            .flatMap { [unowned self] in self.decode($0) }
    }
}

private extension ApiClient {

    func decode<T: Decodable>(_ data: Data) -> Observable<T> {
        return Observable.create { observer in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let decoded = try? decoder.decode(T.self, from: data) else {
                observer.onError(NSError(domain: "Decoding Error", code: 0, userInfo: nil))
                return Disposables.create()
            }

            observer.onNext(decoded)

            return Disposables.create()
        }
    }
}
