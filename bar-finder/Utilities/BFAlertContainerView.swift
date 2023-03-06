//
//  BFAlertContainer.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import UIKit

final class BFAlertContainerView: UIView {

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
    }
  
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        /// Fixes border not updating its color when switching light/dark mode
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
}

extension BFAlertContainerView: ViewConfiguration {
    func setupConstraints() {
        
    }
    
    func buildViewHierarchy() {
        
    }
    
    func configureViews() {
        disableAutoresizingMaskTranslation()
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
    }
}
