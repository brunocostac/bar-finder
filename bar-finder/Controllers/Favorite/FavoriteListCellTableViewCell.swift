//
//  FavoriteListCellTableViewCell.swift
//  bar-finder
//
//  Created by Bruno Costa on 13/02/23.
//

import UIKit

final class FavoriteListCell: UITableViewCell {

    /// Reusable identifier of the cell
    static let reuseIdentifier = "FavoriteListCell"
    
    private let profileImageView: BFProfileImageView = .init(frame: .zero)
    private let nameLabel: BFPrimaryTitleLabel = .init(textAlignment: .left, ofSize: 17)
    private let ratingIcon: UIImageView = .init()
    private let ratingLabel: BFLabel = .init(textAlignment: .left)
    private let tagIcon: UIImageView = .init()
    private let tagLabel: BFLabel = .init(textAlignment: .left)
    
    let cellPadding: CGFloat = 12.0
    let imgAndTextPadding: CGFloat = 12.0
    let infoPiecePadding: CGFloat = 10.0
    let iconSize: CGFloat = 16.0
    let infoTextHeight: CGFloat = 18.0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewConfiguration()
        configAccessibilityForIcons()
    }
    
    func configureCell(with favorite: Favorite) {
        profileImageView.downloadImage(from: favorite.imageURL!)
        nameLabel.text = favorite.name
        
        ratingIcon.image = UIImage(systemName: "star.fill")
        ratingIcon.tintColor = .systemYellow
        ratingLabel.text = "\(favorite.rating)"
        
        tagIcon.image = UIImage(systemName: "tag")
        tagIcon.tintColor = UIColor(named: "AccentColor")
        tagLabel.text = favorite.category
    }
    
    private func configAccessibilityForIcons() {
        ratingIcon.isAccessibilityElement = true
        ratingIcon.accessibilityValue = "icon"
        
        tagIcon.isAccessibilityElement = true
        tagIcon.accessibilityLabel = NSLocalizedString("Categories", comment: "")
        tagIcon.accessibilityValue = "icon"
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension FavoriteListCell: ViewConfiguration {
    func setupConstraints() {
        profileImageView.constrainToSquareSize(44.0)
        ratingIcon.constrainToSquareSize(iconSize)
        tagIcon.constrainToSquareSize(iconSize)
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: cellPadding),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: imgAndTextPadding),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(cellPadding * 4)),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            ratingIcon.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            ratingIcon.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: imgAndTextPadding),
            
            ratingLabel.centerYAnchor.constraint(equalTo: ratingIcon.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingIcon.trailingAnchor, constant: 6),
            ratingLabel.widthAnchor.constraint(equalToConstant: 32),
            ratingLabel.heightAnchor.constraint(equalToConstant: infoTextHeight),
            
            tagIcon.centerYAnchor.constraint(equalTo: ratingIcon.centerYAnchor),
            tagIcon.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: infoPiecePadding),
            
            tagLabel.centerYAnchor.constraint(equalTo: tagIcon.centerYAnchor),
            tagLabel.leadingAnchor.constraint(equalTo: tagIcon.trailingAnchor, constant: 6),
            tagLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(cellPadding * 4)),
            tagLabel.heightAnchor.constraint(equalToConstant: infoTextHeight)
        ])
    }
    
    func buildViewHierarchy() {
        addSubviewsAndDisableAutoresizingMask(profileImageView, nameLabel, ratingIcon, ratingLabel, tagIcon, tagLabel)
    }
    
    func configureViews() {
        accessoryType = .detailButton
    }
}
