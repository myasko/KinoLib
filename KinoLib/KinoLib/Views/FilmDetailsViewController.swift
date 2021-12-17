//
//  DetailsViewController.swift
//  KinoLib
//
//  Created by Георгий Бутров on 19.11.2021.
//

import UIKit
import Firebase

class DetailsViewController: UIViewController {
    var presenter: FilmDetailsPresenter!
    var film: FilmDetails!
    
    var genresLabel: UILabel!
    var descrLabel: UILabel!
    var plotLabel: UILabel!
    var poster: UIImageView!
    var scoreLabel: UILabel!
    var favoriteButton: UIButton!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    required init(film: Film, genres: [String]) {
        super.init(nibName: nil, bundle: nil)
        
        self.presenter = FilmDetailsPresenter(view: self, film: film, genres: genres)
        
        self.film = self.presenter.getFilmDetails()
        
        self.createElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setFavorite(_ favorite: Bool) {
        if (favorite) {
            self.favoriteButton.tintColor = .red
        } else {
            self.favoriteButton.tintColor = .gray
        }
    }
    
    func createElements() {
        self.genresLabel = {
            let label = UILabel()
            
            var genresStr = ""
            for genre in self.film.genres {
                genresStr += genre + ", "
            }
            genresStr = String(genresStr.dropLast(2))
            
            label.text = "Жанры: \(genresStr)"
            label.numberOfLines = 0
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "HelveticaNeue", size: label.font.pointSize)
            label.textColor = Colors.text
            return label
        }()
        
        self.descrLabel = {
            let label = UILabel()
            label.text = "Описание"
            label.font = UIFont(name: "HelveticaNeue-Bold", size: label.font.pointSize * 1.1)
            label.textColor = Colors.text
            return label
        }()
        
        self.plotLabel = {
            let label = UILabel()
            label.text = self.film.overview
            label.numberOfLines = 0
            label.sizeToFit()
            label.font = UIFont(name: "HelveticaNeue", size: label.font.pointSize)
            label.textColor = Colors.text
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.poster = {
            let imageT = NetworkImageView()
            imageT.contentMode = UIView.ContentMode.scaleAspectFit
            imageT.translatesAutoresizingMaskIntoConstraints = false
            if (self.film.posterPath.isEmpty) {
                imageT.image = UIImage(named: "noposter")
            } else {
                imageT.setURL(URL(string: "\(Settings.POSTER_BASE_URL)\(self.film.posterPath)"))
            }
            return imageT
        }()
        
        self.scoreLabel = {
            var rating = "недостаточно оценок"
            if (self.film.voteCount >= 100) {
                rating = "\(self.film.voteAverage) (\(self.film.voteCount) оценок)"
            }
            
            let label = UILabel()
            label.text = "Рейтинг: \(rating)"
            label.font = UIFont(name: "HelveticaNeue", size: label.font.pointSize)
            label.textColor = Colors.text
            return label
        }()
        
        self.favoriteButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            button.contentHorizontalAlignment = .fill
            button.contentVerticalAlignment = .fill
            button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 10, right: 10)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
            button.isHidden = true
            return button
        }()
        
        self.presenter.isFavorite() {
            (favorite) in
            
            self.setFavorite(favorite)
            
            self.favoriteButton.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.title = self.film.title
        setUpScrollView()
        setUpPoster()
        setUpViews()
        setUpStacks()
    }
    
    func setUpScrollView() {
        contentView.backgroundColor = Colors.background1
        scrollView.backgroundColor = Colors.background1
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    func setUpViews() {
        contentView.addSubview(plotLabel)
        plotLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        plotLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        plotLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
    }
    
    func setUpPoster() {
        contentView.addSubview(poster)
        poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        poster.heightAnchor.constraint(equalToConstant: 260).isActive = true
        poster.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 60).isActive = true
        poster.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -60).isActive = true
    }
    
    func setUpStacks() {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 25
        vStack.translatesAutoresizingMaskIntoConstraints = false
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(vStack)
        contentView.addSubview(hStack)
        
        hStack.addArrangedSubview(scoreLabel)
        hStack.addArrangedSubview(favoriteButton)
        favoriteButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        vStack.addArrangedSubview(hStack)
        
        vStack.addArrangedSubview(genresLabel)
        vStack.addArrangedSubview(descrLabel)
        
        vStack.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 8).isActive = true
        vStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        vStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
        plotLabel.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 8).isActive = true
        plotLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -60).isActive = true
    }
    
    @objc func favoriteButtonAction(sender: UIButton!) {
        self.favoriteButton.isEnabled = false
        
        self.presenter.toggleFavoriteStatus() {
            favorite, err in
            
            self.favoriteButton.isEnabled = true
            
            guard let favorite = favorite else {
                return
            }
            
            self.setFavorite(favorite)
        }
    }
}
