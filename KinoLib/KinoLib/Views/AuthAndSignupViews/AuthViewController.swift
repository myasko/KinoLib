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
    
    var usernameLabel: UILabel!
    var usernameInput: UITextField!
    
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
        scrollView.backgroundColor = .white
        
        titleLabel = createLabel(text: "Авторизация")
        titleLabel.font = titleLabel.font.withSize(titleLabel.font.pointSize * 1.25)
        contentView.addSubview(titleLabel)
        
        usernameLabel = createLabel(text: "Логин:")
        contentView.addSubview(usernameLabel)
        
        usernameInput = createTextField(placeholder: "логин")
        contentView.addSubview(usernameInput)
        
        passwordLabel = createLabel(text: "Пароль:")
        contentView.addSubview(passwordLabel)
        
        passwordInput = createTextField(placeholder: "пароль", secure: true)
        contentView.addSubview(passwordInput)
        
        signupButton = createButton(title: "Впервые здесь? К регистрации...", asLabel: true)
        signupButton.addTarget(self, action: #selector(signupButtonAction), for: .touchUpInside)
        contentView.addSubview(signupButton)
        
        submitButton = createButton(title: "Войти")
        submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        contentView.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topMargin),
            
            usernameLabel.leftAnchor.constraint(equalTo: usernameInput.leftAnchor),
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: margin * 2),
            
            usernameInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameInput.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: margin),
            usernameInput.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            
            passwordLabel.leftAnchor.constraint(equalTo: passwordInput.leftAnchor),
            passwordLabel.topAnchor.constraint(equalTo: usernameInput.bottomAnchor, constant: margin * 1.25),
            
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
        let user = UserAuth(
            username: usernameInput.text ?? "",
            password: passwordInput.text ?? ""
        )
        
        let err = presenter.authenticate(user)
        if (err.count > 0) {
            let alert = createAlert(title: "Авторизация", message: "Неверный логин или пароль!")
            showAlert(alert)
            return
        }
        
        let mainViewController = MainViewController()
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    @objc func signupButtonAction(sender: UIButton!) {
        let signupViewController = SignupViewController()
        self.present(signupViewController, animated: true, completion: nil)
    }
}
