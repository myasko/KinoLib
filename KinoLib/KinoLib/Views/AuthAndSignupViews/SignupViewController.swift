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
    
    var emailLabel: UILabel!
    var emailInput: UITextField!
    
    var passwordLabel: UILabel!
    var passwordInput: UITextField!
    
    var passwordConfirmLabel: UILabel!
    var passwordConfirmInput: UITextField!
    
    var submitButton: UIButton!
    
    let topMargin = 100.0
    let bottomMargin = 275.0
    let margin = 10.0
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    func setupView() {
        titleLabel = createLabel(text: "Регистрация")
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
        
        passwordConfirmLabel = createLabel(text: "Подтверждение:")
        contentView.addSubview(passwordConfirmLabel)
        
        passwordConfirmInput = createTextField(placeholder: "подтверждение", secure: true)
        contentView.addSubview(passwordConfirmInput)
        
        submitButton = createButton(title: "Создать")
        submitButton.addTarget(self, action: #selector(authenticateAction), for: .touchUpInside)
        contentView.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: topMargin),
            
            emailLabel.leftAnchor.constraint(equalTo: emailInput.leftAnchor),
            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: margin * 2),
            
            emailInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emailInput.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: margin),
            emailInput.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            passwordLabel.leftAnchor.constraint(equalTo: passwordInput.leftAnchor),
            passwordLabel.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: margin * 1.25),
            
            passwordInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            passwordInput.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: margin),
            passwordInput.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            passwordConfirmLabel.leftAnchor.constraint(equalTo: passwordConfirmInput.leftAnchor),
            passwordConfirmLabel.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: margin * 1.25),
            
            passwordConfirmInput.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            passwordConfirmInput.topAnchor.constraint(equalTo: passwordConfirmLabel.bottomAnchor, constant: margin),
            passwordConfirmInput.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            submitButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: passwordConfirmInput.bottomAnchor, constant: margin * 2),
            submitButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            
            submitButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -bottomMargin),
        ])
    }
    
    @objc func authenticateAction(sender: UIButton!) {
        submitButton.isEnabled = false
        
        let user = UserSignup(
            email: emailInput.text ?? "",
            password: passwordInput.text ?? "",
            passwordConfirm: passwordConfirmInput.text ?? ""
        )
        
        presenter.signup(user, callback: {
            err in
            
            self.submitButton.isEnabled = true
            
            if (err.count > 0) {
                let alert = self.createAlert(title: "Регистрация", message: err)
                self.showAlert(alert)
                return
            }
            
            let alert = self.createAlert(title: "Регистрация", message: "Пользователь успешно зарегистрирован", handler: {
                self.emailInput.text = ""
                self.passwordInput.text = ""
                self.passwordConfirmInput.text = ""
                
                self.dismiss(animated: true, completion: nil)
            })
            self.showAlert(alert)
        })
    }
    
    @objc func navigateToSignupAction(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
}
