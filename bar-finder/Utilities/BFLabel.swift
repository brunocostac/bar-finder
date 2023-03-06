//
//  BFBodyLabel.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import UIKit

class BFLabel: UILabel {
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = .preferredFont(forTextStyle: .body)
    }
}


extension BFLabel: ViewConfiguration {
    func setupConstraints() {
        
    }
    
    func buildViewHierarchy() {
        
    }
    
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = false
        minimumScaleFactor = 1.0
        lineBreakMode = .byTruncatingTail
    }
}
