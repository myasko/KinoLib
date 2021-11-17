//
//  AuthViewController.swift
//  KinoLib
//
//  Created by KoroLion on 13.11.2021.
//

import UIKit

class SignupViewController: FormViewController {
    let presenter = SignupPresenter()
    
    var titleLabel: UILabel!
    
    var usernameLabel: UILabel!
    var usernameInput: UITextField!
    
    var passwordLabel: UILabel!
    var passwordInput: UITextField!
    
    var passwordConfirmLabel: UILabel!
    var passwordConfirmInput: UITextField!
    
    var authButton: UIButton!
    
    var submitButton: UIButton!
    
    let topMargin = 100.0
    let bottomMargin = 275.0
    let margin = 10.0
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    func setupView() {
        scrollView.backgroundColor = .white
        contentView.backgroundColor = .white
        
        titleLabel = createLabel(text: "Регистрация")
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
        
        passwordConfirmLabel = createLabel(text: "Подвтерждение:")
        contentView.addSubview(passwordConfirmLabel)
        
        passwordConfirmInput = createTextField(placeholder: "подтверждение", secure: true)
        contentView.addSubview(passwordConfirmInput)
        
        authButton = createButton(title: "Уже с нами? К авторизации...", asLabel: true)
        authButton.addTarget(self, action: #selector(navigateToSignupAction), for: .touchUpInside)
        contentView.addSubview(authButton)
        
        submitButton = createButton(title: "Создать")
        submitButton.addTarget(self, action: #selector(authenticateAction), for: .touchUpInside)
        contentView.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: topMargin),
            
            usernameLabel.leftAnchor.constraint(equalTo: usernameInput.leftAnchor),
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: margin * 2),
            
            usernameInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            usernameInput.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: margin),
            usernameInput.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            passwordLabel.leftAnchor.constraint(equalTo: passwordInput.leftAnchor),
            passwordLabel.topAnchor.constraint(equalTo: usernameInput.bottomAnchor, constant: margin * 1.25),
            
            passwordInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            passwordInput.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: margin),
            passwordInput.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            passwordConfirmLabel.leftAnchor.constraint(equalTo: passwordConfirmInput.leftAnchor),
            passwordConfirmLabel.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: margin * 1.25),
            
            passwordConfirmInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            passwordConfirmInput.topAnchor.constraint(equalTo: passwordConfirmLabel.bottomAnchor, constant: margin),
            passwordConfirmInput.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            authButton.leftAnchor.constraint(equalTo: passwordConfirmInput.leftAnchor),
            authButton.topAnchor.constraint(equalTo: passwordConfirmInput.bottomAnchor, constant: margin * 1.25),
            
            submitButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: authButton.bottomAnchor, constant: margin),
            submitButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            
            submitButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -bottomMargin),
        ])
    }
    
    @objc func authenticateAction(sender: UIButton!) {
        let user = UserSignup(
            username: usernameInput.text ?? "",
            password: passwordInput.text ?? "",
            passwordConfirm: passwordInput.text ?? ""
        )
        
        let err = presenter.signup(user)
        if (err.count > 0) {
            let alert = createAlert(title: "Регистрация", message: err)
            showAlert(alert)
            return
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func navigateToSignupAction(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
}
