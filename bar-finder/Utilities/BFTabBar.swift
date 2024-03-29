//
//  BFTabBar.swift
//  bar-finder
//
//  Created by Bruno Costa on 13/02/23.
//

import UIKit

class BFTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConfiguration()
    }
        
    private func createSearchNavigationController() -> UINavigationController {
        let searchVC = SearchViewController()
        searchVC.title = NSLocalizedString("Início", comment: "The title of Início view controller")
        searchVC.tabBarItem = UITabBarItem(title: "Início", image: UIImage(systemName: "house"), tag: 0)
        searchVC.tabBarItem.title = "Início"
        return UINavigationController(rootViewController: searchVC)
    }
    
    private func createFavoriteListNavigationController() -> UINavigationController {
        let favListVC = FavoriteListViewController()
        favListVC.title = NSLocalizedString("Favoritos", comment: "The title of Favoritos view controller")
        favListVC.tabBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "star.fill"), tag: 1)
        return UINavigationController(rootViewController: favListVC)
    }
}

extension BFTabBar: ViewConfiguration {
    func setupConstraints() {
        
    }
    
    func buildViewHierarchy() {
        viewControllers = [
          createSearchNavigationController(),
          createFavoriteListNavigationController()
        ]
    }
    
    func configureViews() {
        tabBar.unselectedItemTintColor = .lightGray
    }
}

