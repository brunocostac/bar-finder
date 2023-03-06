//
//  BFAlert.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import Foundation
import UIKit

final class BFAlert: UIViewController {
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private let containerView: BFAlertContainerView = .init()
    private let titleLabel: BFPrimaryTitleLabel = .init(textAlignment: .center, ofSize: 20)
    private let messageLabel: BFLabel = .init(textAlignment: .center)
    private let alertButton: BFButton = .init(withTitle: "OK", color: UIColor(named: "AccentColor")!)
    
    private var titleString: String?
    private var messageString: String?
    private var buttonTitleString: String?
    
    private let edgePadding: CGFloat = 16.0
    
    init(title: String, message: String, btnTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleString = title
        self.messageString = message
        self.buttonTitleString = btnTitle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.75)
        setupContainerView()
        setupTitleLabel()
        setupAlertButton()
        setupMessageLabel()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        /// Fixes border not updating its color when switching light/dark mode
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            containerView.layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
}

// MARK: - UI Configuration
private extension BFAlert {
    private func setupContainerView() {
        view.addSubview(containerView)
        containerView.centerInSuperview()
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: 320),
            containerView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    private func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = NSLocalizedString(titleString ?? "Something went wrong", comment: "The text of the alert title")
        
        titleLabel.constrainToTopHalfOfSuperview(padding: edgePadding)
        NSLayoutConstraint.activate([titleLabel.heightAnchor.constraint(equalToConstant: 28)])
    }
    
    private func setupAlertButton() {
        containerView.addSubview(alertButton)
        alertButton.setTitle(NSLocalizedString(buttonTitleString ?? "OK", comment: "The text of the alert button title"), for: .normal)
        alertButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        alertButton.constrainToBottomHalfOfSuperview(padding: edgePadding)
        NSLayoutConstraint.activate([alertButton.heightAnchor.constraint(equalToConstant: 48)])
    }
    
    @objc private func dismissAlert() -> Void { dismiss(animated: true) }
    
    private func setupMessageLabel() -> Void {
        containerView.addSubview(messageLabel)
        messageLabel.text = NSLocalizedString(messageString ?? "Unable to complete request", comment: "The text of the alert message")
        messageLabel.numberOfLines = 4
        
        messageLabel.constrainToLeadingAndTrailingAnchorsOfSuperview(padding: edgePadding)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: alertButton.topAnchor, constant: -(8))
        ])
    }
}
