//
//  ViewController.swift
//  KinoLib
//
//  Created by Максим on 14.11.2021.
//

import UIKit

class UserViewController: UIViewController {

    
    @IBOutlet weak var userImageView: NetworkImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userLoginLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User = User(firstName: "Кот", lastName: "Котов", login: "goodcat", imageUrl: URL(string: "https://aprikablog.ru/wp-content/uploads/2016/07/nya.jpg"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure(with: user)
    }

    func configure(with user: User) {
        userFullNameLabel.text = "\(user.firstName) \(user.lastName)"
        userLoginLabel.text = "@\(user.login)"
        userImageView.setURL(user.imageUrl)
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
    
    
}
