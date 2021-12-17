//
//  AuthViewController.swift
//  KinoLib
//
//  Created by KoroLion on 17.12.2021.
//

import UIKit
import Firebase


class UserProfileViewController: BaseViewController {
    let margin = 15.0
    let bottomMargin = 50.0
    
    var favoritesLabel: UILabel!
    var logoutButton: UIButton!
    
    override func loadView() {
        super.loadView()
        
        setupView()
    }
    
    func setupView() {
        favoritesLabel = createLabel(text: "Избранное: ")
        favoritesLabel.numberOfLines = 0
        contentView.addSubview(favoritesLabel)
        
        logoutButton = createButton(title: "Выйти")
        logoutButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        contentView.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            favoritesLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: margin),
            favoritesLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -margin),
            favoritesLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: margin),
            
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: favoritesLabel.topAnchor, constant: margin * 5),
            logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            logoutButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -bottomMargin),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let user = Auth.auth().currentUser else {
              return
        }
        
        title = user.email
        
        FirestoreManager.getFavoriteFilms() {
            filmsArr, err in
            
            if (err != nil) {
                print(err)
                return
            }
            
            var newText = "Избранное: "
            for film in filmsArr {
                newText += film.title + ", "
            }
            if filmsArr.count > 0 {
                newText = String(newText.dropLast(2))
            }
            
            self.favoritesLabel.text = newText
            self.favoritesLabel.sizeToFit()
        }
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
