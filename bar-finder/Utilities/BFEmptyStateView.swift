//
//  BFEmptyStateView.swift
//  bar-finder
//
//  Created by Bruno Costa on 15/02/23.
//

import UIKit

final class BFEmptyStateView: UIView {

    private let logoImageView: UIImageView = .init()
    private let messageLabel: BFPrimaryTitleLabel = .init(textAlignment: .center, ofSize: 26)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        backgroundColor = .systemBackground
        messageLabel.text = NSLocalizedString(message, comment: "The text of the empty state view")
        
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension BFEmptyStateView: ViewConfiguration {
    func setupConstraints() {
        messageLabel.constrainToLeadingAndTrailingAnchorsOfSuperview(padding: 40.0)
        logoImageView.constrainToLeadingAndTrailingAnchorsOfSuperview(padding: 40.0)
        
        // extra constraints
        NSLayoutConstraint.activate([
            messageLabel.bottomAnchor.constraint(equalTo: logoImageView.topAnchor, constant: -16),
            
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
        ])
    }
    
    func buildViewHierarchy() {
        addSubview(logoImageView)
        addSubview(messageLabel)
    }
    
    func configureViews() {
        messageLabel.numberOfLines = 3
        logoImageView.image = BFImages.noResults
        logoImageView.disableAutoresizingMaskTranslation()
    }
}
