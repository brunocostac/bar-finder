//
//  BFSecondaryTitleLabel.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import UIKit

final class BFSecondaryTitleLabel: UILabel {

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    convenience init(ofSize size: CGFloat) {
        self.init(frame: .zero)
        font = .systemFont(ofSize: size, weight: .medium)
    }

    func setNew(color: UIColor) -> Void {
        textColor = color
    }
}

extension BFSecondaryTitleLabel: ViewConfiguration {
    func setupConstraints() {
        
    }
    
    func buildViewHierarchy() {
        
    }
    
    func configureViews() {
        disableAutoresizingMaskTranslation()

        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = false
        minimumScaleFactor = 1.0
        lineBreakMode = .byTruncatingTail
    }
}

