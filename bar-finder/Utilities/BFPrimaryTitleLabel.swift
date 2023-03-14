//
//  BFPrimaryTitleLabel.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import UIKit

class BFPrimaryTitleLabel: UILabel {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    convenience init(textAlignment: NSTextAlignment, ofSize fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = .systemFont(ofSize: fontSize, weight: .bold)
    }
}

extension BFPrimaryTitleLabel: ViewConfiguration {
    func setupConstraints() {
        
    }
    
    func buildViewHierarchy() {
        
    }
    
    func configureViews() {
        disableAutoresizingMaskTranslation()
        textColor = .gray
        //adjustsFontSizeToFitWidth = true
       // minimumScaleFactor = 0.9
       // lineBreakMode = .byTruncatingTail
    }
}
