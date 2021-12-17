//
//  AuthViewController.swift
//  KinoLib
//
//  Created by KoroLion on 13.11.2021.
//

import UIKit

class AuthViewController: FormViewController {
    let presenter = AuthPresenter()
    
    var titleLabel: UILabel!
    
    var emailLabel: UILabel!
    var emailInput: UITextField!
    
    var passwordLabel: UILabel!
    var passwordInput: UITextField!
    
    var signupButton: UIButton!
    
    var submitButton: UIButton!
    
    let topMargin = 100.0
    let bottomMargin = 275.0
    let margin = 15.0
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    func setupView() {
        title = "KinoLib"
        self.tabBarController?.tabBar.isHidden = true
        
        titleLabel = createLabel(text: "Авторизация")
        titleLabel.font = titleLabel.font.withSize(titleLabel.font.pointSize * 1.25)
        contentView.addSubview(titleLabel)
        
        emailLabel = createLabel(text: "EMail:")
        contentView.addSubview(emailLabel)
        
        emailInput = createTextField(placeholder: "email")
        contentView.addSubview(emailInput)
        
        passwordLabel = createLabel(text: "Пароль:")
        contentView.addSubview(passwordLabel)
        
        passwordInput = createTextField(placeholder: "пароль", secure: true)
        contentView.addSubview(passwordInput)
        
        signupButton = createButton(title: "Впервые здесь? К регистрации", asLabel: true)
        signupButton.addTarget(self, action: #selector(signupButtonAction), for: .touchUpInside)
        contentView.addSubview(signupButton)
        
        submitButton = createButton(title: "Войти")
        submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        contentView.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topMargin),
            
            emailLabel.leftAnchor.constraint(equalTo: emailInput.leftAnchor),
            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: margin * 2),
            
            emailInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailInput.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: margin),
            emailInput.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            
            passwordLabel.leftAnchor.constraint(equalTo: passwordInput.leftAnchor),
            passwordLabel.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: margin * 1.25),
            
            passwordInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordInput.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: margin),
            passwordInput.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            
            signupButton.leftAnchor.constraint(equalTo: passwordInput.leftAnchor),
            signupButton.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: margin * 1.25),
            
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: margin),
            submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            submitButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -bottomMargin),
        ])
    }
    
    @objc func submitButtonAction(sender: UIButton!) {
        submitButton.isEnabled = false
        
        let user = UserAuth(
            email: emailInput.text ?? "",
            password: passwordInput.text ?? ""
        )
        
        presenter.authenticate(user, callback: {
            err in
            
            self.submitButton.isEnabled = true
          
            if (err.count > 0) {
                let alert = self.createAlert(title: "Авторизация", message: err)
                self.showAlert(alert)
                return
            }
            
            self.passwordInput.text = ""
            self.navigateToMain()
        })
    }
    
    @objc func signupButtonAction(sender: UIButton!) {
        let signupViewController = SignupViewController()
        self.present(signupViewController, animated: true, completion: nil)
    }
}
