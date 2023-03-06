//
//  BusinessDetailsViewController.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import UIKit

class BusinessInformationHeaderViewController: UIViewController {
    
    private let businessImageView: BFBusinessImageView = .init(frame: .zero)
    private let nameLabel: BFPrimaryTitleLabel = .init(textAlignment: .natural, ofSize: 28)
    private let distanceIcon: UIImageView = .init()
    private let distanceLabel: BFSecondaryTitleLabel = .init(ofSize: 17)
    private let openStatusIcon: UIImageView = .init()
    private let openStatusLabel: BFSecondaryTitleLabel = .init(ofSize: 17)
    private let costIcon: UIImageView = .init()
    private let costLabel: BFSecondaryTitleLabel = .init(ofSize: 17)
    private let underlyingCostLabel: BFSecondaryTitleLabel = .init(ofSize: 17)
    private let ratingIcon: UIImageView = .init()
    private let ratingLabel: BFSecondaryTitleLabel = .init(ofSize: 17)
    let imgAndTextPadding: CGFloat = 12.0
    let infoPiecePadding: CGFloat = 10.0
    let iconSize: CGFloat = 18.0
    let infoTextHeight: CGFloat = 22.0
    
    
    private var business: Business!
    private var searchedLocation: String!
    
    
    init(for business: Business, near location: String) {
        super.init(nibName: nil, bundle: nil)
        self.business = business
        self.searchedLocation = location
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConfiguration()
        setupAccessibilityForIcons()
    }
}

extension BusinessInformationHeaderViewController: ViewConfiguration {
    func setupConstraints() {
        setupProfileImageViewConstraints()
        setupNameLabelConstraints()
        setupDistanceLabelConstraints()
        setupDistanceIconConstraints()
        setupOpenStatusIconConstraints()
        setupOpenStatusLabelConstraints()
        setupCostLabelConstraints()
        setupCostIconConstraints()
        setupUnderlyingCostLabelConstraints()
        setupRatingIconConstraints()
        setupRatingLabelConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubviewsAndDisableAutoresizingMask(businessImageView,
                                                  nameLabel,
                                                  distanceIcon,
                                                  distanceLabel,
                                                  openStatusIcon,
                                                  openStatusLabel,
                                                  costIcon,
                                                  costLabel,
                                                  underlyingCostLabel,
                                                  ratingIcon,
                                                  ratingLabel)
    }
    
    func configureViews() {
        businessImageView.downloadImage(from: business.imageURL)
        
        nameLabel.text = business.name

        distanceIcon.image =  (business.distance != nil) ? UIImage(systemName: "arrow.triangle.swap") : UIImage()
        distanceIcon.tintColor = .secondaryLabel
        distanceLabel.text = business.distance?.localizedDistanceString(from: searchedLocation)
        distanceLabel.setNew(color: business.distance ?? 0.0 <= 1_000 ? .systemGreen : .systemOrange)
        
        openStatusIcon.image = business.isClosed ? UIImage(systemName: "door.left.hand.closed"): UIImage(systemName: "door.left.hand.open")
        openStatusIcon.tintColor = .secondaryLabel
        openStatusLabel.text = business.isClosed ?
            NSLocalizedString("Fechado", comment: "") :
            NSLocalizedString("Aberto", comment: "")
        openStatusLabel.setNew(color: business.isClosed ? .systemPink : .systemGreen)
        
        costIcon.image = UIImage(systemName: "banknote")
        costIcon.tintColor = .secondaryLabel
        costLabel.text = business.price
        underlyingCostLabel.text = "$$$$"
        underlyingCostLabel.setNew(color: .quaternaryLabel)
        
        ratingIcon.image = UIImage(systemName: "star.fill")
        ratingIcon.tintColor = .systemYellow
        ratingLabel.text = "\(business.rating)"
    }
}

extension BusinessInformationHeaderViewController {
    
    private func setupProfileImageViewConstraints() {
        
        NSLayoutConstraint.activate([
            businessImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            businessImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            businessImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            businessImageView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: businessImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: businessImageView.leadingAnchor, constant: imgAndTextPadding),
            nameLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupDistanceLabelConstraints() {
        NSLayoutConstraint.activate([
            distanceLabel.centerYAnchor.constraint(equalTo: distanceIcon.centerYAnchor),
            distanceLabel.leadingAnchor.constraint(equalTo: distanceIcon.trailingAnchor, constant: 6),
            distanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            distanceLabel.heightAnchor.constraint(equalToConstant: business.distance != nil ? infoTextHeight : 0)
        ])
    }
    
    private func setupDistanceIconConstraints() {
        distanceIcon.constrainToSquareSize(business.distance != nil ? iconSize : 0)
        
        NSLayoutConstraint.activate([
            distanceIcon.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: infoPiecePadding),
            distanceIcon.leadingAnchor.constraint(equalTo: businessImageView.leadingAnchor, constant: imgAndTextPadding),
        ])
    }
    
    private func setupOpenStatusIconConstraints() {
        openStatusIcon.constrainToSquareSize(iconSize)
        
        NSLayoutConstraint.activate([
            openStatusIcon.topAnchor.constraint(equalTo: distanceIcon.bottomAnchor, constant: infoPiecePadding),
            openStatusIcon.leadingAnchor.constraint(equalTo:  businessImageView.leadingAnchor, constant: imgAndTextPadding)
        ])
    }
    
    private func setupOpenStatusLabelConstraints() {
        NSLayoutConstraint.activate([
            openStatusLabel.centerYAnchor.constraint(equalTo: openStatusIcon.centerYAnchor),
            openStatusLabel.leadingAnchor.constraint(equalTo: openStatusIcon.trailingAnchor, constant: 6),
            openStatusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            openStatusLabel.heightAnchor.constraint(equalToConstant: infoTextHeight)
        ])
    }
    
    private func setupCostIconConstraints() {
        costIcon.constrainToSquareSize(iconSize)
        
        NSLayoutConstraint.activate([
            costIcon.leadingAnchor.constraint(equalTo: businessImageView.leadingAnchor, constant: imgAndTextPadding),
            costIcon.topAnchor.constraint(equalTo: openStatusIcon.bottomAnchor, constant: infoPiecePadding)
        ])
    }
    
    private func setupUnderlyingCostLabelConstraints() {
        NSLayoutConstraint.activate([
            underlyingCostLabel.centerYAnchor.constraint(equalTo: costIcon.centerYAnchor),
            underlyingCostLabel.leadingAnchor.constraint(equalTo: costIcon.trailingAnchor, constant: 6),
            underlyingCostLabel.widthAnchor.constraint(equalToConstant: 56),
            underlyingCostLabel.heightAnchor.constraint(equalToConstant: infoTextHeight)
        ])
    }
    
    private func setupCostLabelConstraints() {
        NSLayoutConstraint.activate([
            costLabel.centerYAnchor.constraint(equalTo: costIcon.centerYAnchor),
            costLabel.leadingAnchor.constraint(equalTo: costIcon.trailingAnchor, constant: 6),
            costLabel.widthAnchor.constraint(equalToConstant: 56),
            costLabel.heightAnchor.constraint(equalToConstant: infoTextHeight)
        ])
    }
    
   
    private func setupRatingIconConstraints() {
        ratingIcon.constrainToSquareSize(iconSize)
        
        NSLayoutConstraint.activate([
            ratingIcon.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            ratingIcon.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: infoPiecePadding),
        ])
    }
    
    private func setupRatingLabelConstraints() {
        NSLayoutConstraint.activate([
            ratingLabel.centerYAnchor.constraint(equalTo: ratingIcon.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingIcon.trailingAnchor, constant: 6)
        ])
    }
    
    private func setupAccessibilityForIcons() {
        distanceIcon.isAccessibilityElement = true
        distanceIcon.accessibilityLabel = NSLocalizedString("Distance", comment: "The noun")
        distanceIcon.accessibilityValue = "icon"
        
        openStatusIcon.isAccessibilityElement = true
        openStatusIcon.accessibilityLabel = NSLocalizedString("Is open or closed?", comment: "")
        openStatusIcon.accessibilityValue = "icon"
        
        costIcon.isAccessibilityElement = true
        costIcon.accessibilityLabel = NSLocalizedString("Cost", comment: "The noun")
        costIcon.accessibilityValue = "icon"
        
        ratingIcon.isAccessibilityElement = true
        ratingIcon.accessibilityLabel = NSLocalizedString("Rating", comment: "The noun")
        ratingIcon.accessibilityValue = "icon"
    }
}
