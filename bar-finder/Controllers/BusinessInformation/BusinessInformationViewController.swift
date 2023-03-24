//
//  BusinessInformationViewController.swift
//  bar-finder
//
//  Created by Bruno Costa on 13/02/23.
//

import UIKit
import MapKit

protocol BusinessInformationViewControllerDelegate: AnyObject {
    func businessInformationViewControllerDidDismiss(_ viewController: BusinessInformationViewController)
}

class BusinessInformationViewController: UIViewController, LoadableScreen {
    
    var containerView: UIView!
 
    var business: Business!
    private var searchedLocation: String = .init()

    private var scrollView: UIScrollView = .init()
    private var contentView: UIView = .init()
    
    private var headerView: UIView = .init()
    private var detailView: UIView = .init()
    private var mapHostingView: UIView = .init()
    private var favBarBtn: UIBarButtonItem = .init(image: UIImage(systemName: "star"), style: .plain, target: nil, action: #selector(favoriteButtonClicked))
    
    private var isFavorite = false
    
    let edgePadding: CGFloat = 12.0
    let itemPadding: CGFloat = 24.0
    
    weak var delegate: BusinessInformationViewControllerDelegate?
    
    init(for business: Business, near location: String = NSLocalizedString("searched location", comment: "The default distance-from location info of a business")) {
        super.init(nibName: nil, bundle: nil)
        self.business = business
        self.searchedLocation = location
        self.checkIsFavorite(business: business)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewConfiguration()
        self.setupChildControllers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.businessInformationViewControllerDidDismiss(self)
    }
}

extension BusinessInformationViewController: ViewConfiguration {
    func setupConstraints() {
        setupScrollViewConstraints()
        setupContentViewConstraints()
        setupHeaderViewConstraints()
        setupDetailViewConstraints()
        setupMapHostingViewConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubviewsAndDisableAutoresizingMask(scrollView)
        scrollView.addSubviewsAndDisableAutoresizingMask(contentView)
        contentView.addSubviewsAndDisableAutoresizingMask(headerView, detailView, mapHostingView)
    }
    
    func configureViews() {
        view.backgroundColor = .systemBackground
        title = business.name
        setupNavigationBarButtons()
    }
}

private extension BusinessInformationViewController {
    private func setupChildControllers() {
        addViewControllerToContainerView(BusinessInformationHeaderViewController(for: business, near: searchedLocation), to: headerView)
        addViewControllerToContainerView(BusinessInformationDetailsViewController(for: business), to: detailView)
        addViewControllerToContainerView(BusinessInformationMapViewController(for: business, delegate: self), to: mapHostingView)
    }
    
    private func setupScrollViewConstraints() {
        scrollView.pinToSuperviewEdges()
    }
    
    private func setupContentViewConstraints() {
        contentView.pinToSuperviewEdges()
        // extra constraints
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 860)
        ])
    }
    
    private func setupHeaderViewConstraints() {
        headerView.constrainToTopHalfOfSuperview(padding: edgePadding)
        
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupDetailViewConstraints() {
        detailView.constrainToLeadingAndTrailingAnchorsOfSuperview(padding: edgePadding)
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: itemPadding),
            detailView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupMapHostingViewConstraints() {
        mapHostingView.constrainToBottomHalfOfSuperview(padding: edgePadding)
        
        NSLayoutConstraint.activate([
            mapHostingView.heightAnchor.constraint(equalToConstant: 340)
        ])
    }
    
    
    private func setupNavigationBarButtons() {
        favBarBtn.target = self
        favBarBtn.image = UIImage(systemName: isFavorite ? "star.fill" : "star")
        favBarBtn.isAccessibilityElement = true
        favBarBtn.accessibilityLabel = NSLocalizedString("Adicionar aos favoritos", comment: "Label de acessibilidade do botão favoritar")
        navigationItem.setRightBarButtonItems([favBarBtn], animated: true)
        
        
        let closeBarBtn: UIBarButtonItem =  UIBarButtonItem(title: "Fechar", style: .plain, target: self, action: #selector(dismissVC))
        closeBarBtn.isAccessibilityElement = true
        closeBarBtn.accessibilityLabel = NSLocalizedString("Fechar tela", comment: "Label de acessibilidade do botão fechar")
        navigationItem.setLeftBarButtonItems([closeBarBtn], animated: true)
    }
        
    @objc private func dismissVC() {
        dismiss(animated: true)
        self.delegate?.businessInformationViewControllerDidDismiss(self)
    }
    
    @objc private func favoriteButtonClicked() {
        self.toggleFavorite(business: business)
        
        if self.isFavorite {
            let alert = UIAlertController(title: "Sucesso", message: " \(business.name) foi salvo nos favoritos", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
    
        } else {
            let alert = UIAlertController(title: "Sucesso", message: "\(business.name) foi removido dos favoritos", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in

            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func checkIsFavorite(business: Business) {
        let favorite = FavoriteManager().fetch(withId: business.id)
        if favorite != nil {
            self.isFavorite = true
        } else {
            self.isFavorite = false
        }
    }
    
    func toggleFavorite(business: Business) {
        if !isFavorite {
            FavoriteManager().save(business: business)
        } else {
            FavoriteManager().remove(withId: business.id)
        }
        
        self.checkIsFavorite(business: business)
        DispatchQueue.main.async {
            self.favBarBtn.image = UIImage(systemName: self.isFavorite ? "star.fill" : "star")
        }
    }
}

extension BusinessInformationViewController: MapNavigationRequestDelegate {
    func didRequestMapNavigation(to business: Business) -> Void {
        let annotation = BusinessMapAnnotation.generate(from: business)
        let placemark = MKPlacemark(coordinate: annotation.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = annotation.title
        mapItem.openInMaps()
    }
}

