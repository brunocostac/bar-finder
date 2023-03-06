//
//  BFBusinessImageView.swift
//  bar-finder
//
//  Created by Bruno Costa on 01/03/23.
//

import UIKit

class BFBusinessImageView: UIImageView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
    }
}

extension BFBusinessImageView: ViewConfiguration {
    func setupConstraints() {
    }
    
    func buildViewHierarchy() {
        
    }
    
    func configureViews() {
        disableAutoresizingMaskTranslation()
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
}

extension BFBusinessImageView {
    func downloadImage(from urlString: String) -> Void {
        Task {
            if let downloadedImage = await ImageDataService.shared.getImage(from: urlString) {
                image = downloadedImage
                image = resizeImage(image: image!, targetSize: CGSizeMake(200, 200))
               } else {
                image = BFImages.businessWithoutImage
                contentMode = .scaleAspectFit
            }
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let aspectRatio = image.size.width / image.size.height

        var newSize = targetSize
        if aspectRatio > 1 {
            newSize.height = newSize.width / aspectRatio
        } else {
            newSize.width = newSize.height * aspectRatio
        }

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)

        image.draw(in: CGRect(origin: CGPoint.zero, size: newSize), blendMode: .normal, alpha: 1.0)

        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        // Return the resized image
        return resizedImage
    }
}
