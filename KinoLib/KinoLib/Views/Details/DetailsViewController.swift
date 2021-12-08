//
//  DetailsViewController.swift
//  KinoLib
//
//  Created by Георгий Бутров on 19.11.2021.
//

import UIKit

class DetailsViewController: UIViewController {
    var presenter: FilmDetailsPresenter!
    var film: Film!
    
    var titleLabel: UILabel!
    var genresLabel: UILabel!
    var plotLabel: UILabel!
    var poster: UIImageView!
    var scoreLabel: UILabel!
    var favoriteButton: UIButton!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    required init(film: Film) {
        super.init(nibName: nil, bundle: nil)
        
        self.presenter = FilmDetailsPresenter(view: self)
        
        self.film = film
        
        self.createElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createElements() {
        self.titleLabel = {
            let label = UILabel()
            label.text = film.title
            label.sizeToFit()
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "HelveticaNeue-Bold", size: label.font.pointSize)
            label.textColor = .black
            return label
        }()
        
        self.genresLabel = {
           let label = UILabel()
            label.text = "Жанры: "
            label.numberOfLines = 0
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "HelveticaNeue", size: label.font.pointSize)
            label.textColor = .black
            return label
        }()
        
        self.plotLabel = {
            let label = UILabel()
            label.text = self.film.overview
            label.numberOfLines = 0
            label.sizeToFit()
            label.font = UIFont(name: "HelveticaNeue", size: label.font.pointSize)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.poster = {
            let imageT = NetworkImageView()
            imageT.contentMode = UIView.ContentMode.scaleAspectFit
            imageT.translatesAutoresizingMaskIntoConstraints = false
            imageT.setURL(URL(string: "https://image.tmdb.org/t/p/w185\(self.film.posterPath)"))
            return imageT
        }()
        
        self.scoreLabel = {
           let label = UILabel()
            label.text = "Рейтинг: 10"
            label.font = UIFont(name: "HelveticaNeue", size: label.font.pointSize)
            label.textColor = .black
            return label
        }()
        
        self.favoriteButton = {
            let button = UIButton()
            button.backgroundColor = .white
            button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            button.tintColor = .gray
            button.contentHorizontalAlignment = .fill
            button.contentVerticalAlignment = .fill
            button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 10, right: 10)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpScrollView()
        setUpPoster()
        setUpViews()
        setUpStacks()
    }
    
    func setUpScrollView() {
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
        
        scrollView.backgroundColor = .white
    }
    
    func setUpViews() {
        contentView.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 40).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -40).isActive = true
        
        contentView.addSubview(plotLabel)
        plotLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        plotLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        plotLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        plotLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setUpPoster() {
        contentView.addSubview(poster)
        poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        poster.heightAnchor.constraint(equalToConstant: 260).isActive = true
        poster.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 60).isActive = true
        poster.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -60).isActive = true
    }
    
    func setUpStacks() {
        let vStack = UIStackView()
        vStack.axis = .vertical
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
        vStack.addArrangedSubview(genresLabel)
        vStack.addArrangedSubview(hStack)
        
        
        vStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        vStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        vStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
        plotLabel.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 8).isActive = true
        plotLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -60).isActive = true
    }
    
    
    /*func toggleFavorite(_ sender: UIButton) {
        presenter.toggleFavoriteStatus()
    }
    
    private func setStatusForFavoriteButton() {
        favoriteButton.tintColor = presenter.isFavorite ? .red : .gray
    }*/
}
