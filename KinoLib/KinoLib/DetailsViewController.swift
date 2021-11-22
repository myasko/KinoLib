//
//  DetailsViewController.swift
//  KinoLib
//
//  Created by Георгий Бутров on 19.11.2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Very very big film title"
        label.sizeToFit()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: label.font.pointSize)
        return label
    }()
    
    var plotLabel: UILabel = {
        let label = UILabel()
        label.text = "Holo is a powerful wolf deity who is celebrated and revered in the small town of Pasloe for blessing the annual harvest. Yet as years go by and the villagers become more self-sufficient, Holo, who stylizes herself as the Wise Wolf of Yoitsu, has been reduced to a mere folk tale. When a traveling merchant named Kraft Lawrence stops at Pasloe, Holo offers to become his business partner if he eventually takes her to her northern home of Yoitsu. The savvy trader recognizes Holo's unusual ability to evaluate a person's character and accepts her proposition. Now in the possession of both sharp business skills and a charismatic negotiator, Lawrence inches closer to his goal of opening his own shop. However, as Lawrence travels the countryside with Holo in search of economic opportunities, he begins to realize that his aspirations are slowly morphing into something unexpected. Holo is a powerful wolf deity who is celebrated and revered in the small town of Pasloe for blessing the annual harvest. Yet as years go by and the villagers become more self-sufficient, Holo, who stylizes herself as the Wise Wolf of Yoitsu, has been reduced to a mere folk tale. When a traveling merchant named Kraft Lawrence stops at Pasloe, Holo offers to become his business partner if he eventually takes her to her northern home of Yoitsu. The savvy trader recognizes Holo's unusual ability to evaluate a person's character and accepts her proposition. Now in the possession of both sharp business skills and a charismatic negotiator, Lawrence inches closer to his goal of opening his own shop. However, as Lawrence travels the countryside with Holo in search of economic opportunities, he begins to realize that his aspirations are slowly morphing into something unexpected."
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = UIFont(name: "HelveticaNeue", size: label.font.pointSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var imageV = UIImage(named: "holo")
    
    var poster: UIImageView = {
        
        let imageT = UIImageView()
        imageT.contentMode = UIView.ContentMode.scaleAspectFit
        imageT.translatesAutoresizingMaskIntoConstraints = false
        return imageT
    }()
    
    var genresLabel: UILabel = {
       let label = UILabel()
        label.text = "Detective, drama, comedy"
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: label.font.pointSize)
        return label
    }()
    
    var scoreLabel: UILabel = {
       let label = UILabel()
        label.text = "score: 10"
        label.font = UIFont(name: "HelveticaNeue", size: label.font.pointSize)
        return label
    }()
   
    
    var presenter: FilmDetailsPresenterProtocol!
    
    var favoriteButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = ""
        button.setImage(UIImage(named: "heart.fill"), for: .normal)
        return button
    }()
    
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
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 60).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -60).isActive = true
        
        contentView.addSubview(plotLabel)
        plotLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        plotLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        plotLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        plotLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setUpPoster() {
        contentView.addSubview(poster)
        poster.image = imageV
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
        favoriteButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        vStack.addArrangedSubview(genresLabel)
        vStack.addArrangedSubview(hStack)
        
        vStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        vStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        vStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 16).isActive = true
        
        plotLabel.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 8).isActive = true
        
    }
    
    
    
    
    func toggleFavorite(_ sender: UIButton) {
        presenter.toggleFavoriteStatus()
    }
    
    private func setStatusForFavoriteButton() {
        favoriteButton.tintColor = presenter.isFavorite ? .red : .gray
    }
}
