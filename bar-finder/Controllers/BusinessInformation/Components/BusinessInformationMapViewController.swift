//
//  BusinessInformationMapViewController.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import UIKit
import MapKit

internal protocol MapNavigationRequestDelegate: AnyObject {
    func didRequestMapNavigation(to business: Business) -> Void
}

class BusinessInformationMapViewController: UIViewController {
    
    private var mapView: MKMapView!
    private var callToActionButton: BFButton!
    private var business: Business!
    weak var delegate: MapNavigationRequestDelegate!
    
    init(for business: Business, delegate: MapNavigationRequestDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.business = business
        self.mapView = .init()
        self.callToActionButton = .init(withTitle: "Me leve até lá!")
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConfiguration()
    }
}

extension BusinessInformationMapViewController: ViewConfiguration {
    func setupConstraints() {
        mapView.constrainToTopHalfOfSuperview()
        callToActionButton.constrainToBottomHalfOfSuperview()
        
        NSLayoutConstraint.activate([
            mapView.heightAnchor.constraint(equalToConstant: 280),
            callToActionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func buildViewHierarchy() {
        view.addSubviewsAndDisableAutoresizingMask(mapView, callToActionButton)
    }
    
    func configureViews() {
        setupMapView()
        setupMapRegionAndAnnotation()
        setupActionButton()
    }
}


extension BusinessInformationMapViewController {

    private func setupMapView() {
        mapView.isUserInteractionEnabled = true
        mapView.layer.cornerRadius = 8.0
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = UIColor.systemGray4.cgColor
        mapView.layer.masksToBounds = false
        mapView.clipsToBounds = true
    }
    
    private func setupMapRegionAndAnnotation() {
        let annotation = BusinessMapAnnotation.generate(from: business)
        let zoomLevel = 0.005
        mapView.region = MKCoordinateRegion(center: annotation.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
        mapView.addAnnotation(annotation)
    }
    
    private func setupActionButton() {
        callToActionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    @objc private func didTapActionButton() {
        delegate.didRequestMapNavigation(to: business)
    }
}
