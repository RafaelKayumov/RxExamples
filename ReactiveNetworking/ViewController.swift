//
//  ViewController.swift
//  ReactiveNetworking
//
//  Created by Rafael Kayumov on 08/06/2020.
//  Copyright © 2020 Rafael Kayumov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let kCellIdentifier = "issueCellIdentifier"

class ViewController: UIViewController {

    private var searchBar = UISearchBar()
    private let tableView = UITableView()

    var latestRepositoryName: Observable<String> {
        return self.searchBar
            .rx
            .text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    private let disposeBag = DisposeBag()
    private lazy var githubIssuesProvider: GithubIssuesProviderProtocol = {
        let networking = Networking(urlSession: URLSession.shared, qos: .background)
        let apiClient = ApiClient(networking: networking)
        return GithubIssuesProvider(apiClient: apiClient, repoName: latestRepositoryName)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        buildUI()
        registerCells()

        DispatchQueue.main.async {
            self.setupBindings()
        }
    }

    private func setupBindings() {
        githubIssuesProvider.issuesListOutput
            .bind(to: tableView.rx.items(cellIdentifier: kCellIdentifier)) { row, model, cell in
                cell.textLabel?.text = model.title
            }.disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] _ in
                guard self.searchBar.isFirstResponder else { return }
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }

    private func buildUI() {
        view.addSubview(searchBar)
        view.addSubview(tableView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }

    private func registerCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
    }
}

