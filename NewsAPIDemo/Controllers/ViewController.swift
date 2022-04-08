//
//  ViewController.swift
//  NewsAPIDemo
//
//  Created by Rathakrishnan Ramasamy on 2022/4/2.
//

import UIKit
import SnapKit
import SafariServices

class ViewController: UIViewController {
    
    
    
    private var articles: [Articles] = []
    private var breakingNews: [Articles] = []
    private var sources: [Source] = []
    private var viewModels = [SourceViewModel]()
    let pickerVc = PickerViewController()
    
    let searchController: UISearchController = {
        let results = SearchResultViewController()
        let vc = UISearchController(searchResultsController: results)
        vc.searchBar.placeholder = "Search News..."
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    } ()
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return ViewController.createSectionLayout(section: sectionIndex)
            
        })
        return collectionView
    }()
    
//    let items = ["Business","Entertainment","Health","Science","Sports","Technology"]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News Today"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sources", style: .done, target: self, action: #selector(rightButtonClicked))
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(collectionView)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
       
        
        navigationItem.searchController = searchController
        
        pickerVc.delegate = self
        
        configureCollectionView()
        fetchData(with: "")
        fetchSource()
 
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionView.frame = view.bounds
      

    }
    
    @objc func rightButtonClicked() {
        
        guard !self.sources.isEmpty else {
            return
        }
       
        self.viewModels = self.sources.compactMap({
            SourceViewModel(id: $0.id, name: $0.name, url: $0.url ?? "")
        })
        
        self.pickerVc.configure(with: self.viewModels)
        present(self.pickerVc, animated: true)
    }
    
    
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        collectionView.register(BreakingNewsCollectionViewCell.self, forCellWithReuseIdentifier: BreakingNewsCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            //Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(180)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            // group
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(180)), subitem: item, count: 1)
            // section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        case 1:
            //Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)))
            // group
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitem: item, count: 1)
            // section
            return NSCollectionLayoutSection(group: group)
        default :
            //Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)))
            // group
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitem: item, count: 1)
            // section
            return NSCollectionLayoutSection(group: group)
        }
        
        
    }
    
    
    private func fetchData(with source: String) {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        
        APICaller.shared.getBreakingNews {[weak self] result in
            DispatchQueue.main.async {
                defer {
                    group.leave()
                }
                switch result {
                case .success(let articles):
                    self?.breakingNews = articles
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        APICaller.shared.getAllNews(with: source, completion: { [weak self] result in
            
            defer {
                group.leave()
            }
            switch result {
            case .success(let news):
                self?.articles = news
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        })
        
        group.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
    
    private func fetchSource() {
        
        APICaller.shared.getSources {[weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
               
                switch result {
                case .success(let sources):
                    strongSelf.sources = sources
                    guard !strongSelf.sources.isEmpty else {
                        return
                    }
                   
                    strongSelf.viewModels = strongSelf.sources.compactMap({
                        SourceViewModel(id: $0.id, name: $0.name, url: $0.url ?? "")
                    })
                    
                    strongSelf.pickerVc.configure(with: strongSelf.viewModels)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? breakingNews.count : articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreakingNewsCollectionViewCell.identifier, for: indexPath) as? BreakingNewsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let model = breakingNews[indexPath.row]
            cell.configure(with: NewsViewModel(imgUrl: model.urlToImage, content: model.content ?? "", title: model.title ?? ""))
            
            return cell
            
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as? NewsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let model = articles[indexPath.row]
            cell.configure(with: NewsViewModel(imgUrl: model.urlToImage, content: model.content ?? "", title: model.title ?? ""))
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            guard let url = URL(string:self.breakingNews[indexPath.row].url ?? "") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
        else {
            guard let url = URL(string:self.articles[indexPath.row].url ?? "") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
        
    }
    
}

extension ViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultController = searchController.searchResultsController as? SearchResultViewController, let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
            
        }
        
     
        
        APICaller.shared.searchNews(with: query, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    resultController.update(with: articles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        })
 
    }
    
}

extension ViewController: PickerViewControllerDelegate {
    func didOkButtonTapped(selectedName: String, selectedId: String) {
        print("selected Item: \(selectedName) and id \(selectedId)")
       // self.fetchData(with: selectedId)
        
        guard let url = URL(string:selectedId) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
//        navigationController?.pushViewController(vc, animated: true)
    }
}
