//
//  BFTextField.swift
//  bar-finder
//
//  Created by Bruno Costa on 13/02/23.
//

import UIKit

final class BFTextField: UITextField {
   
    let imageView: UIImageView = {
       let imageView = UIImageView()
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupViewConfiguration()
    }
    
    init(withPlaceholder placeholder: String? = nil, imagePlaceHolder: UIImage? = nil) {
        super.init(frame: .zero)
        configure(placeholder: placeholder, imagePlaceHolder: imagePlaceHolder)
        setupViewConfiguration()
    }
    
    private func configure(placeholder: String? = nil, imagePlaceHolder: UIImage? = nil) -> Void {
        self.placeholder = NSLocalizedString(placeholder ?? "", comment: "")
        self.imageView.image = imagePlaceHolder
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        /// Fixes border not updating its color when switching light/dark mode
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
}

extension BFTextField: ViewConfiguration {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
        ])
    }
    
    func buildViewHierarchy() {
        addSubview(imageView)
    }
    
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = .preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        leftView = imageView
        leftViewMode = .always
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        autocapitalizationType = .none
        returnKeyType = .go
        clearButtonMode = .whileEditing
    
        imageView.tintColor = UIColor(red: 0.98, green: 0.39, blue: 0.25, alpha: 1.0)
    }
}
