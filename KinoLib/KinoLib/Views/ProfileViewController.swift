//
//  ProfileViewController.swift
//  KinoLib
//
//  Created by Георгий Бутров on 17.12.2021.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userEmailLabel: UILabel! = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = UIFont(name: "HelveticaNeue", size: label.font.pointSize) // Сделать жирным и выделяющимся
        label.textColor = Colors.text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    var userFullNameLabel: UILabel! = {
        let label = UILabel()
        label.text = "BBB"
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = UIFont(name: "HelveticaNeue", size: label.font.pointSize)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var logoutButton: UIButton!
    
    let buttonsTableView = UITableView()
    
//    func creatElements() {
//
//        self.userFullNameLabel = {
//            let label = UILabel()
//            label.text = "AAA"
//            label.textAlignment = .center
//            label.numberOfLines = 0
//            label.sizeToFit()
//            label.font = UIFont(name: "HelveticaNeue", size: label.font.pointSize) // Сделать жирным и выделяющимся
//            label.textColor = Colors.text // поменять на Colors.text
//            label.translatesAutoresizingMaskIntoConstraints = false
//            return label
//        }()
//
//        self.userEmailLabel = {
//            let label = UILabel()
//            label.text = "BBB"
//            label.textAlignment = .center
//            label.numberOfLines = 0
//            label.sizeToFit()
//            label.font = UIFont(name: "HelveticaNeue", size: label.font.pointSize)
//            label.textColor = Colors.text
//            label.translatesAutoresizingMaskIntoConstraints = false
//            return label
//        }()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(buttonsTableView)
        buttonsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        buttonsTableView.delegate = self
        buttonsTableView.dataSource = self

        buttonsTableView.translatesAutoresizingMaskIntoConstraints = false
        buttonsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        buttonsTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        buttonsTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        buttonsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        
        buttonsTableView.backgroundColor = Colors.background2
        buttonsTableView.separatorColor = Colors.highlight
        
        setUpView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        buttonsTableView.translatesAutoresizingMaskIntoConstraints = false
//        buttonsTableView.frame = .init(x: 10, y: 500, width: 350, height: 40)
//        buttonsTableView.frame.width =
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = buttonsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "ИЗБРАННОЕ"
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = Colors.background2
        return cell
    }
    
    func createButton(title: String, asLabel: Bool = false) -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(Colors.highlight, for: .normal)
        btn.setTitleColor(Colors.text, for: .highlighted)
        
        if (!asLabel) {
            btn.setTitleColor(Colors.text, for: .normal)
            btn.backgroundColor = Colors.highlight
            btn.layer.borderWidth = 1.0
            btn.layer.cornerRadius = 4.0
            btn.layer.borderColor = Colors.highlight.cgColor
        }
        
        return btn
    }
    
    func setUpView() {
        guard let user = Auth.auth().currentUser else { return }
        
        view.backgroundColor = Colors.background2
        
        view.addSubview(userEmailLabel)
        userEmailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        userEmailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        userEmailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 120).isActive = true
//        userEmailLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100).isActive = true
        userEmailLabel.text = "\(user.email ?? "user email")"
        
        logoutButton = createButton(title: "Выйти")
        logoutButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutButton.topAnchor.constraint(equalTo: userEmailLabel.bottomAnchor, constant: 20).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteListVC = FavoritesViewController()
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        backItem.tintColor = Colors.highlight
        navigationItem.backBarButtonItem = backItem
        buttonsTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(favoriteListVC, animated: true)
    }
    
    @objc func logoutButtonAction(sender: UIButton!) {
        do {
            try Auth.auth().signOut()
            
            let authVC = AuthViewController()
            authVC.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(authVC, animated: true)
        } catch {
            print("Unable to logout!")
        }
    }
    
}
