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
                
    }
    
    func setUpUI() {
        
    }
    
    @IBAction func toggleFavorite(_ sender: UIButton) {
        presenter.toggleFavoriteStatus()
    }
    private func setStatusForFavoriteButton() {
        favoriteButton.tintColor = presenter.isFavorite ? .red : .gray
    }
}
