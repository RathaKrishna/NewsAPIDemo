//
//  SearchResultViewController.swift
//  NewsAPIDemo
//
//  Created by Rathakrishnan Ramasamy on 07/04/22.
//

import UIKit
import SafariServices

class SearchResultViewController: UIViewController {

    private var articles = [Articles]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
       
    
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    public func update(with results: [Articles]) {
        self.articles = results
        tableView.reloadData()
    }
}


extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        let model = articles[indexPath.row]
        cell.configure(with: NewsViewModel(imgUrl: model.urlToImage, content: model.description ?? "", title: model.title ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = articles[indexPath.row]
        
        guard let url = URL(string:model.url ?? "") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
}
