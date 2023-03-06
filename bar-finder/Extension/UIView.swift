//
//  UIView.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import UIKit

extension UIView {
    
    func disableAutoresizingMaskTranslation() -> Void { translatesAutoresizingMaskIntoConstraints = false }
    
    func addSubviews(_ subviews: UIView...) {
        for subview in subviews {
            addSubview(subview)
        }
    }
    
    func addSubviewsAndDisableAutoresizingMask(_ subviews: UIView...) {
        for subview in subviews {
            addSubview(subview)
            subview.disableAutoresizingMaskTranslation()
        }
    }
    
    func pinToSuperviewEdges() {
        guard let superview = superview else {
            fatalError("View has no superview!")
        }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    func centerInSuperview() {
        guard let superview = superview else {
            fatalError("View has no superview!")
        }
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
    
    func constrainToTopHalfOfSuperview(padding: CGFloat = 0.0) {
        guard let superview = superview else {
            fatalError("View has no superview!")
        }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0.0),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -(0.0))
        ])
    }
    
    func constrainToBottomHalfOfSuperview(padding: CGFloat = 0.0) {
        guard let superview = superview else {
            fatalError("View has no superview!")
        }
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -(padding)),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -(padding))
        ])
    }
    
    func constrainToLeadingAndTrailingAnchorsOfSuperview(padding: CGFloat = 0.0) {
        
        guard let superview = superview else {
            fatalError("View has no superview!")
        }
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -(padding))
        ])
    }
    
    /// Constrains the height and width anchors to the same constant value, resulting in a square.
    func constrainToSquareSize(_ constant: CGFloat) {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: constant),
            widthAnchor.constraint(equalToConstant: constant)
        ])
    }
}

