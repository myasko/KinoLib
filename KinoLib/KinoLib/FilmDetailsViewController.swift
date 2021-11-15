//
//  FilmDetailsViewController.swift
//  DetailsKinoLib
//
//  Created by Георгий Бутров on 29.10.2021.
//

import UIKit


class FilmDetailsViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var plotLabel: UILabel!
    @IBOutlet var genresLable: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var grades: UILabel!
    
    var presenter: FilmDetailsPresenterProtocol!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpUI()
        
    }
    
    func setUpUI() {
        favoriteButton.titleLabel?.text = ""
    }
    
//    func setUpNameLabel() {
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(nameLabel)
//        nameLabel.text = "jopa"
//        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
//        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
//    }
    
//    func setUpfavoriteButton() {
//        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(favoriteButton)
//        favoriteButton.setImage(UIImage(named: "love"), for: .normal)
//        favoriteButton.tintColor = .red
//        favoriteButton.backgroundColor = .green
//
//        favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 400).isActive = true
//        favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
//        favoriteButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        favoriteButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
//    }
    
//    func setUpImage() {
//
//    }
    
    func toggleFavorite(_ sender: UIButton) {
        presenter.toggleFavoriteStatus()
    }
    
    private func setStatusForFavoriteButton() {
        favoriteButton.tintColor = presenter.isFavorite ? .red : .gray
    }
}
