//
//  BFProfileImageView.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import UIKit

class BFProfileImageView: UIImageView {
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private let placeholderImage: UIImage = BFImages.businessImgPlaceholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.height / 2
    }
}

extension BFProfileImageView: ViewConfiguration {
    func setupConstraints() {
        
    }
    
    func buildViewHierarchy() {
        
    }
    
    func configureViews() {
        disableAutoresizingMaskTranslation()

        image = placeholderImage
        layer.masksToBounds = false
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        clipsToBounds = true
    }
}

extension BFProfileImageView {
    func downloadImage(from urlString: String) -> Void {
        Task {
            if let downloadedImage = await ImageDataService.shared.getImage(from: urlString) {
                image = downloadedImage
               } else {
                image = BFImages.businessWithoutImage
                contentMode = .scaleAspectFit
            }
        }
    }
}
