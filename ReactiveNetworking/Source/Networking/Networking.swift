//
//  Networking.swift
//  ReactiveNetworking
//
//  Created by Rafael Kayumov on 08/06/2020.
//  Copyright © 2020 Rafael Kayumov. All rights reserved.
//

import RxSwift
import RxCocoa

class Networking {

    private let urlSession: URLSession
    private let scheduler: ConcurrentDispatchQueueScheduler

    init(urlSession: URLSession, qos: DispatchQoS) {
        self.urlSession = urlSession
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: qos)
    }
}

extension Networking: NetworkingProtocol {

    internal func request(_ request: URLRequest) -> Observable<Data> {
        urlSession
            .rx.data(request: request)
            .subscribeOn(scheduler)
    }
}
