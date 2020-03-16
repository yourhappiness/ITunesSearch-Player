//
//  ViewController.swift
//  iOSArchitecturesDemo
//
//  Created by ekireev on 14.02.2018.
//  Copyright © 2018 ekireev. All rights reserved.
//

import UIKit



// MARK: -


enum SearchMode: String {
    case app = "Apps"
    case songs = "Songs"
  
    func searchService() -> SearchViewProtocol {
        switch self {
        case .app:
            return SearchViewITunesServiceAdapter(interactor: SearchViewInteractorForApps())
        case .songs:
            return SearchViewITunesServiceAdapter(interactor: SearchViewInteractorForSongs())
        }
    }
}


// SearchViewController: View, Presenter, Interactor, Entity, Router

final class SearchViewController: UIViewController { //View
    
    // MARK: - Private Properties
    
    private var searchView: SearchView {
        return self.view as! SearchView
    }
  
    private var searchMode: SearchMode = .app
    
    private lazy var searchService: SearchViewProtocol = self.searchMode.searchService() //Presenter
    private var searchResults: [SearchItemProtocol] = []
    
//    private struct Constants {
//        static let reuseIdentifier = "reuseId"
//    }
  
    
//    static func makeAppSearch()  -> SearchViewController{
//        let vc = SearchViewController()
//        vc.searchService = SearchViewITunesServiceAdapter(interactor: SearchViewInteractor())
//        return vc
//    }
//
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = SearchView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.searchView.searchBar.delegate = self
      
        self.searchView.tableView.register(UITableViewCell.self,
                                           forCellReuseIdentifier: "UITableViewCell")
        SearchItemAppAdapter.registerCell(in: self.searchView.tableView)
        SearchItemSongAdapter.registerCell(in: self.searchView.tableView)
        
        self.searchView.tableView.delegate = self
        self.searchView.tableView.dataSource = self
      
        self.searchView.searchChoiceControl.addTarget(self, action: #selector(self.controlValueChanged(sender:)), for: .valueChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.throbber(show: false)
    }
    
    // MARK: - Private
    
    private func throbber(show: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
    
    private func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNoResults() {
        self.searchView.emptyResultView.isHidden = false
    }
    
    private func hideNoResults() {
        self.searchView.emptyResultView.isHidden = true
    }
    
    private func request(with query: String) {
        self.throbber(show: true)
        self.searchResults.removeAll()
        self.searchView.tableView.reloadData()
        
        self.searchService.loadData(query: query) { [weak self] (items: [SearchItemProtocol], error: Error?) in
            
            DispatchQueue.main.async {
                if let error = error {
                    self?.showError(error: error)
                } else if items.count <= 0 {
                    self?.showNoResults()
                } else {
                    self?.searchResults.append(contentsOf: items)
                    self?.hideNoResults()
                    self?.searchView.tableView.isHidden = false
                    self?.searchView.tableView.reloadData()
                }
            }            
        }
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.searchResults[indexPath.row]
        let cell = item.getCell(in: tableView, indexPath: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.searchResults[indexPath.row]
        item.didSelect(in: self)
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            searchBar.resignFirstResponder()
            return
        }
        if query.count == 0 {
            searchBar.resignFirstResponder()
            return
        }
        self.request(with: query)
    }
}

//MARK: -
extension SearchViewController {
  
    @objc func controlValueChanged(sender: UISegmentedControl) {
      switch sender.selectedSegmentIndex {
      case 0:
        self.didChangedMode(newMode: .app)
      case 1:
        self.didChangedMode(newMode: .songs)
      default:
        return
      }
    }
    
    func didChangedMode(newMode: SearchMode) {
        self.searchService = newMode.searchService()
        self.request(with: self.searchView.searchBar.text ?? "")
    }
}
