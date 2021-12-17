//
//  AuthViewController.swift
//  KinoLib
//
//  Created by KoroLion on 17.12.2021.
//

import UIKit
import Firebase


class UserProfileViewController: FormViewController {
    let margin = 15.0
    let bottomMargin = 50.0
    
    var logoutButton: UIButton!
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    func setupView() {
        title = "KinoLib"
        
        logoutButton = createButton(title: "Выйти")
        logoutButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        contentView.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: margin),
            logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            logoutButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -bottomMargin),
        ])
    }
    
    @objc func logoutButtonAction(sender: UIButton!) {
        do {
            try Auth.auth().signOut()
            self.navigateToAuth()
        } catch {
            print("Unable to logout!")
        }
    }
}
