//
//  BusinessListViewController.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import UIKit

class BusinessListViewController: UIViewController, LoadableScreen {
    
    let searchController: UISearchController = .init()
    internal enum CollectionSection { case main }
    
    private var businessType: String!
    private var searchedLocation: String!
    
    private var isInSearchMode: Bool = false
    
    internal var containerView: UIView!
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<CollectionSection, Business>!
    
    init(for businessType: String, near location: String) {
        super.init(nibName: nil, bundle: nil)
        self.businessType = businessType
        self.searchedLocation = location
    }
    
    private var businessList: [Business] = [] {
        didSet {
            updateCollectionView(using: businessList)
            showEmptyStateViewIfNeeded()
        }
    }

    private var filteredBusinessList: [Business] = [] {
        didSet {
            updateCollectionView(using: filteredBusinessList)
            showEmptyStateViewIfNeeded()
        }
    }
    
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConfiguration()
        setupDataSource()
        fetchBusinessList(for: businessType, near: searchedLocation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension BusinessListViewController: ViewConfiguration {
    func setupConstraints() {
     
    }
    
    func buildViewHierarchy() {
        collectionView = .init(frame: view.bounds, collectionViewLayout: UIHelper.makeFourColumnFlowLayout(in: view))
        view.addSubview(collectionView)
    }
    
    func configureViews() {
        view.backgroundColor = .systemBackground
        title = businessType.capitalized.localizedStringNear( searchedLocation.capitalized)
        setupCancelButton()
        setupTapGestureInView()
        setupCollectionView()
        setupSearchBar()
    }
}

// MARK: - UI/Data Configurations
private extension BusinessListViewController {
    private func setupCancelButton() {
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelButtonClicked))
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    @objc func cancelButtonClicked() {
        DispatchQueue.main.async {
            self.searchController.searchBar.text = ""
        }
        self.isInSearchMode = false
        self.dismissKeyboard()
        self.updateCollectionView(using: businessList)
        self.showEmptyStateViewIfNeeded()
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(BusinessCell.self, forCellWithReuseIdentifier: BusinessCell.reuseIdentifier)
        collectionView.delegate = self
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: collectionView,
                           cellProvider: { (collectionView, indexPath, business) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BusinessCell.reuseIdentifier, for: indexPath) as! BusinessCell
            cell.configureCell(with: business)
            return cell
        })
    }
    
    private func setupTapGestureInView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        searchController.searchBar.resignFirstResponder()
    }

    private func setupSearchBar() {
        searchController.searchBar.placeholder = NSLocalizedString("Buscar um bar, restaurante...", comment: "O placeholder do pesquisar em Business list controller")
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchBarStyle = .minimal
        searchController.delegate = self
        searchController.searchBar.showsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func fetchBusinessList(for businessType: String, near location: String) {
        startLoading()
        
        defer { stopLoading() }
        
        Task {
            do {
                let result: BusinessServerResponse = try await BusinessDataService.shared.fetchData(nearby: location, businessType: businessType)
                updateBusinessListAndUI(with: result.businesses.sorted { $0.distance ?? 0 < $1.distance ?? 1 })
            } catch let error as BusinessDataService.NetworkError {
                presentCustomAlert(message: error.rawValue)
            } catch { presentDefaultNetworkErrorAlert() }
        }
    }
    
    private func showEmptyStateViewIfNeeded() {
        if businessList.isEmpty {
            if isInSearchMode && filteredBusinessList.isEmpty {
                collectionView.isHidden = true
                showEmptyStateView(saying: "Sem resultados", in: view)
            } else {
                // Recover businessList
                collectionView.isHidden = false
                hideEmptyStateView()
                updateCollectionView(using: businessList)
            }
        } else {
            collectionView.isHidden = false
            hideEmptyStateView()
            updateCollectionView(using: businessList)
        }
    }
    
    private func updateBusinessListAndUI(with newBusinessList: [Business]) {
        businessList.append(contentsOf: newBusinessList)
    }
    
    
    func hideEmptyStateView() {
        self.collectionView.isHidden = false
        for subview in view.subviews {
            if subview.tag == 123 {
                subview.removeFromSuperview()
                break
            }
        }
    }
    
    private func updateCollectionView(using businessList: [Business]) {
        var snapshot: NSDiffableDataSourceSnapshot<CollectionSection, Business> = .init()
        snapshot.appendSections([.main])
        snapshot.appendItems(businessList)
        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension BusinessListViewController: UISearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.isInSearchMode = false
            self.filteredBusinessList.removeAll()
            self.showEmptyStateViewIfNeeded()
        } else {
            self.isInSearchMode = true
            self.filteredBusinessList = businessList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            self.showEmptyStateViewIfNeeded()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isInSearchMode = false
        self.searchController.searchBar.text = ""
        self.searchController.searchBar.showsCancelButton = false
        self.dismissKeyboard()
        self.updateCollectionView(using: businessList)
    }
}


extension BusinessListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = isInSearchMode ? filteredBusinessList[indexPath.item] : businessList[indexPath.item]
        let targetVC: BusinessInformationViewController = .init(for: selectedItem, near: searchedLocation)
        let navController: UINavigationController = .init(rootViewController: targetVC)
        present(navController, animated: true)
    }
}

extension BusinessListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            isInSearchMode = false
            filteredBusinessList.removeAll()
            updateCollectionView(using: businessList)
            navigationItem.rightBarButtonItem?.isHidden = true
            return
        }

        isInSearchMode = true
        filteredBusinessList = businessList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        updateCollectionView(using: filteredBusinessList)
        navigationItem.rightBarButtonItem?.isHidden = false
    }
}
