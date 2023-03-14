//
//  ViewController.swift
//  bar-finder
//
//  Created by Bruno Costa on 09/02/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let logoImageView: UIImageView = .init()
    
    private let locationTextField: BFTextField = .init(withPlaceholder: "Qual é a sua localização?", imagePlaceHolder: BFImages.location)
    private let businessTypeTextField: BFTextField = .init(withPlaceholder: "Pizza, cerveja, hamburger...", imagePlaceHolder: BFImages.businessType)
    private let searchButton: BFButton = .init(withTitle: "Buscar")
    
    private var isLocationEntered: Bool { !locationTextField.text!.isEmpty }
    private var isBusinessTypeEntered: Bool { !businessTypeTextField.text!.isEmpty }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViewConfiguration()
        setupKeyboarHiding()
        setupDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    func setupLogoViewConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 300),
            logoImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
   
    
    private func setupTextFieldsConstraints() {
        
        NSLayoutConstraint.activate([
            locationTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 0),
            locationTextField.heightAnchor.constraint(equalToConstant: 44),
            locationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            locationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            
            businessTypeTextField.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 24),
            businessTypeTextField.heightAnchor.constraint(equalToConstant: 44),
            businessTypeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            businessTypeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func setupSearchButtonConstraints() {
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48),
            searchButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

extension SearchViewController: ViewConfiguration {
    func setupConstraints() {
        setupLogoViewConstraints()
        setupTextFieldsConstraints()
        setupSearchButtonConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(logoImageView)
        view.addSubviewsAndDisableAutoresizingMask(locationTextField, businessTypeTextField)
        view.addSubview(searchButton)
    }
    
    func configureViews() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.39, blue: 0.25, alpha: 1.0)
        logoImageView.image = BFImages.bfLogo
        locationTextField.delegate = self
        businessTypeTextField.delegate = self
        searchButton.addTarget(self, action: #selector(validateAndPushBusinessListVC), for: .touchUpInside)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTextField.resignFirstResponder()
        businessTypeTextField.resignFirstResponder()
        validateAndPushBusinessListVC()
        return true
    }
    
    @objc private func validateAndPushBusinessListVC() {
        guard isLocationEntered else {
            presentCustomAlert(title: "Sem localização?",
                         message: "Por favor digite o endereço, rua, ou cep 😊.")
            return
        }
        
        guard isBusinessTypeEntered else {
            presentCustomAlert(title: "Não sabe o que pesquisar?",
                         message: "Por favor, digite um tipo de comida.\nEx: 'pizza', ou 'café'?")
            return
        }
         
         locationTextField.resignFirstResponder()
         businessTypeTextField.resignFirstResponder()
         
        
        let targetVC: BusinessListViewController = .init(for: businessTypeTextField.text!,
                                             near: locationTextField.text!)
        navigationController?.pushViewController(targetVC, animated: true)
    }
}


extension SearchViewController {
    private func setupKeyboarHiding() -> Void {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func setupDismissKeyboardTapGesture() -> Void {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}
