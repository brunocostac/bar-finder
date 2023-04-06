//
//  FavoriteListViewControllerTableViewController.swift
//  bar-finder
//
//  Created by Bruno Costa on 13/02/23.
//

import UIKit

class FavoriteListViewController: UIViewController {
    
    var allFavorites: [Favorite] = []
    private var business: Business?
    var tableView = UITableView()
    var favoriteManager: FavoriteManagerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("Favoritos", comment: "")
        overrideUserInterfaceStyle = .light 
        self.setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.favoriteManager = FavoriteManager()
        self.fetchFavorites()
        self.setupEmptyStateView()
    }
    
    func fetchFavorites() {
        self.allFavorites = (favoriteManager?.fetchAll())!
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        self.tableView = .init(frame: view.bounds, style: .insetGrouped)
        view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 72
        self.tableView.register(FavoriteListCell.self, forCellReuseIdentifier: FavoriteListCell.reuseIdentifier)
    }
    
    func setupEmptyStateView() {
        if allFavorites.isEmpty {
            DispatchQueue.main.async {
                self.showEmptyStateView(saying: "Sem favoritos", in: self.view)
            }
            
        } else {
            DispatchQueue.main.async {
                self.removeEmptyStateView()
            }
        }
    }
    
    func removeEmptyStateView() {
        for subview in view.subviews {
            if subview.tag == 123 {
                subview.removeFromSuperview()
                break
            }
        }
    }
    
    func presentBusinessInformationViewController(businessId: String) {
        let targetVC = BusinessInformationViewController(for: nil, with: businessId)
        targetVC.delegate = self
        
        let navController = UINavigationController(rootViewController: targetVC)
        present(navController, animated: true)
    }
}


extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteListCell.reuseIdentifier,
                                                for: indexPath) as! FavoriteListCell
        cell.configureCell(with: allFavorites[indexPath.row])
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedFavorite = allFavorites[indexPath.row]
        self.presentBusinessInformationViewController(businessId: selectedFavorite.id!)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let selectedFavorite = allFavorites[indexPath.row]
        self.presentBusinessInformationViewController(businessId: selectedFavorite.id!)
    }
}

extension FavoriteListViewController: BusinessInformationViewControllerDelegate {
    func businessInformationViewControllerDidDismiss(_ viewController: BusinessInformationViewController) {
        self.fetchFavorites()
        self.setupEmptyStateView()
    }
}
