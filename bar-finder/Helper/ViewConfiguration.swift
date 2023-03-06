//
//  ViewConfiguration.swift
//  bar-finder
//
//  Created by Bruno Costa on 17/02/23.
//

import Foundation

protocol ViewConfiguration: AnyObject {
    func setupConstraints()
    func buildViewHierarchy()
    func configureViews()
    func setupViewConfiguration()
}

extension ViewConfiguration {
    func setupViewConfiguration() {
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }
}
