//
//  BusinessInfoDetailsViewController.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import UIKit

class BusinessInformationDetailsViewController: UIViewController {
    private let locationIcon: UIImageView = .init()
    private let locationLabel: BFLabel = .init(textAlignment: .left)
    private let phoneIcon: UIImageView = .init()
    private let phoneLabel: BFLabel = .init(textAlignment: .left)
    private let tagIcon: UIImageView = .init()
    private let tagLabel: BFLabel = .init(textAlignment: .left)
    private let linkIcon: UIImageView = .init()
    private let linkLabel: BFLabel = .init(textAlignment: .left)
    
    let imgAndTextPadding: CGFloat = 6.0
    let infoPiecePadding: CGFloat = 16.0
    let iconSize: CGFloat = 18.0
    let infoTextHeight: CGFloat = 22.0
    
    private var business: Business!
    
    init(for business: Business) {
        super.init(nibName: nil, bundle: nil)
        self.business = business
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViewConfiguration()
        setupAccessibilityForIcons()
    }
}

extension BusinessInformationDetailsViewController: ViewConfiguration {
    func setupConstraints() {
        setupLocationIconConstraints()
        setupLocationLabelConstraints()
        setupPhoneIconConstraints()
        setupPhoneLabelConstraints()
        setupTagIconConstraints()
        setupTagLabelConstraints()
        setupLinkIconConstraints()
        setupLinkLabelConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubviewsAndDisableAutoresizingMask(locationIcon,
                                                  locationLabel,
                                                  phoneIcon,
                                                  phoneLabel,
                                                  tagIcon,
                                                  tagLabel,
                                                  linkIcon,
                                                  linkLabel)
    }
    
    func configureViews() {
        // Location
        locationIcon.image = UIImage(systemName: "mappin")
        locationIcon.tintColor = .secondaryLabel
        locationLabel.text = business.location?.displayAddress?.joined(separator: ", ") ?? NSLocalizedString("No address information available", comment: "")
        
        // Phone
        phoneIcon.image = UIImage(systemName: "phone")
        phoneIcon.tintColor = .secondaryLabel
        switch business.displayPhone {
            case .none:
              phoneLabel.text = NSLocalizedString("No phone number available", comment: "")
            case .some(let phoneNo):
               phoneLabel.text = phoneNo.isEmpty ? NSLocalizedString("No phone number available", comment: "") : phoneNo
        }
        
        // Tags
        tagIcon.image = UIImage(systemName: "tag")
        tagIcon.tintColor = .secondaryLabel
        tagLabel.text = business.categories.first?.title
        
        // Link
        linkIcon.image = UIImage(systemName: "globe")
        linkIcon.tintColor = .secondaryLabel
        
        let yelpAttrString = NSMutableAttributedString(string: NSLocalizedString("Descubra mais em Yelp", comment: ""))
        yelpAttrString.addAttribute(.link, value: business.yelpUrl, range: NSRange(location: 0, length: yelpAttrString.length))
        linkLabel.attributedText = yelpAttrString
        linkLabel.isUserInteractionEnabled = true
        linkLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(yelpUrlTapped)))
    }
}

extension BusinessInformationDetailsViewController {
    
    private func setupLocationIconConstraints() {
        locationIcon.constrainToSquareSize(iconSize)
        
        NSLayoutConstraint.activate([
            locationIcon.topAnchor.constraint(equalTo: view.topAnchor),
            locationIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func setupLocationLabelConstraints() {
        NSLayoutConstraint.activate([
            locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: imgAndTextPadding),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: infoTextHeight)
        ])
    }
    
    private func setupPhoneIconConstraints() {
        phoneIcon.constrainToSquareSize(iconSize)
        NSLayoutConstraint.activate([
            phoneIcon.topAnchor.constraint(equalTo: locationIcon.bottomAnchor, constant: infoPiecePadding),
            phoneIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func setupPhoneLabelConstraints() {
        NSLayoutConstraint.activate([
            phoneLabel.centerYAnchor.constraint(equalTo: phoneIcon.centerYAnchor),
            phoneLabel.leadingAnchor.constraint(equalTo: phoneIcon.trailingAnchor, constant: imgAndTextPadding),
            phoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            phoneLabel.heightAnchor.constraint(equalToConstant: infoTextHeight)
        ])
    }
    
    private func setupTagIconConstraints() {
        tagIcon.constrainToSquareSize(iconSize)
        
        NSLayoutConstraint.activate([
            tagIcon.topAnchor.constraint(equalTo: phoneIcon.bottomAnchor, constant: infoPiecePadding),
            tagIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func setupTagLabelConstraints() {
        NSLayoutConstraint.activate([
            tagLabel.centerYAnchor.constraint(equalTo: tagIcon.centerYAnchor),
            tagLabel.leadingAnchor.constraint(equalTo: tagIcon.trailingAnchor, constant: imgAndTextPadding),
            tagLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tagLabel.heightAnchor.constraint(equalToConstant: infoTextHeight)
        ])
    }
    
    private func setupLinkIconConstraints() {
        linkIcon.constrainToSquareSize(iconSize)
        
        NSLayoutConstraint.activate([
            linkIcon.topAnchor.constraint(equalTo: tagIcon.bottomAnchor, constant: infoPiecePadding),
            linkIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func setupLinkLabelConstraints() {
        NSLayoutConstraint.activate([
            linkLabel.centerYAnchor.constraint(equalTo: linkIcon.centerYAnchor),
            linkLabel.leadingAnchor.constraint(equalTo: linkIcon.trailingAnchor, constant: imgAndTextPadding),
            linkLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            linkLabel.heightAnchor.constraint(equalToConstant: infoTextHeight)
        ])
    }

    private func setupAccessibilityForIcons() {
        locationIcon.isAccessibilityElement = true
        locationIcon.accessibilityLabel = NSLocalizedString("Location", comment: "")
        locationIcon.accessibilityValue = "icon"
        
        phoneIcon.isAccessibilityElement = true
        phoneIcon.accessibilityLabel = NSLocalizedString("Phone number", comment: "")
        phoneIcon.accessibilityValue = "icon"
        
        tagIcon.isAccessibilityElement = true
        tagIcon.accessibilityLabel = NSLocalizedString("Categories", comment: "")
        tagIcon.accessibilityValue = "icon"
        
        linkIcon.isAccessibilityElement = true
        linkIcon.accessibilityLabel = NSLocalizedString("Website URL", comment: "")
        linkIcon.accessibilityValue = "icon"
    }
    
    @objc private func yelpUrlTapped(_ sender: UITapGestureRecognizer) {
        guard let url = URL(string: business.yelpUrl) else { return }
        UIApplication.shared.open(url)
    }
}
