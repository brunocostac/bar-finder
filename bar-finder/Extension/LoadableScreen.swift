//
//  LoadableScreen.swift
//  bar-finder
//
//  Created by Bruno Costa on 15/02/23.
//

import UIKit

/// Allows any conformed view controller to show or dismiss spinning indicator when loading data.
/// For example, when downloading data over internet.
protocol LoadableScreen: AnyObject {
    var containerView: UIView! { get set }
    func startLoading()
    func stopLoading()
}

extension LoadableScreen where Self: UIViewController {
    func startLoading() {
        containerView = .init(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0.0
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.containerView.alpha = 0.8
        }
        
        let indicatorOverlay: UIActivityIndicatorView = .init(style: .large)
        containerView.addSubview(indicatorOverlay)
        indicatorOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            indicatorOverlay.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            indicatorOverlay.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        indicatorOverlay.startAnimating()
    }
    
    func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.containerView.removeFromSuperview()
            self?.containerView = nil
        }
    }
}
