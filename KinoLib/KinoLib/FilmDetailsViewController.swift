//
//  FilmDetailsViewController.swift
//  DetailsKinoLib
//
//  Created by Георгий Бутров on 29.10.2021.
//

import UIKit


class FilmDetailsViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var plotLabel: UILabel!
    @IBOutlet var genresLable: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var image: UIImage!
    
    
    
    var presenter: FilmDetailsPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
              setUpUI()
    }
    
    func setUpUI() {
        
    }
    
    private func creatNameLabelConstraints() {
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    @IBAction func toggleFavorite(_ sender: UIButton) {
        presenter.toggleFavoriteStatus()
    }
    private func setStatusForFavoriteButton() {
        favoriteButton.tintColor = presenter.isFavorite ? .red : .gray
    }
}
