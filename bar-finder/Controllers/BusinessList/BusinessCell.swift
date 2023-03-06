//
//  BusinessCell.swift
//  bar-finder
//
//  Created by Bruno Costa on 15/02/23.
//

import UIKit

final class BusinessCell: UICollectionViewCell {
    /// Reusable identifier of the cell
    static let reuseIdentifier = "BusinessCell"
    
    private let profileImageView: BFProfileImageView = .init(frame: .zero)
    private let businessNameLabel: BFPrimaryTitleLabel = .init(textAlignment: .center, ofSize: 13)
    private let edgePadding: CGFloat = 4.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    func configureCell(with business: Business) {
        businessNameLabel.text = business.name
        profileImageView.downloadImage(from: business.imageURL)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension BusinessCell: ViewConfiguration {
    func setupConstraints() {
        profileImageView.constrainToTopHalfOfSuperview(padding: edgePadding)
        businessNameLabel.constrainToLeadingAndTrailingAnchorsOfSuperview(padding: edgePadding)
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            businessNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4),
            businessNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func buildViewHierarchy() {
        addSubviews(profileImageView, businessNameLabel)
    }
    
    func configureViews() {
        
    }
}
