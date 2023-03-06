//
//  BFButton.swift
//  bar-finder
//
//  Created by Bruno Costa on 13/02/23.
//

import UIKit

final class BFButton: UIButton {
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    convenience init(withTitle title: String, color: UIColor = UIColor(named: "AccentColor")!) {
        self.init(frame: .zero)
        setupViewConfiguration()
        set(title: title, withColor: color)
    }
    
    func set(title: String, withColor color: UIColor) {
        configuration?.title = NSLocalizedString(title, comment: "The title for the button")
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
    }
}

extension BFButton: ViewConfiguration {
    func setupConstraints() {
        
    }
    
    func buildViewHierarchy() {
        
    }
    
    func configureViews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        
        titleLabel?.font = .preferredFont(forTextStyle: .headline)
        setTitleColor(UIColor(named: "AccentColor"), for: .normal)
    }
}
