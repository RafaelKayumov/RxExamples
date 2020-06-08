//
//  NetworkingProtocol.swift
//  ReactiveNetworking
//
//  Created by Rafael Kayumov on 08/06/2020.
//  Copyright © 2020 Rafael Kayumov. All rights reserved.
//

import RxSwift

protocol NetworkingProtocol {
    func request(_ request: URLRequest) -> Observable<Data>
}
