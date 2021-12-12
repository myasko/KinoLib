//
//  CollectionViewCell.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 30.10.2021.
//

import UIKit
import PinLayout

final class MainCollectionViewCell: UICollectionViewCell, CellProtocol {
    
    static var name: String {
        return "MainCollectionViewCell"
    }
    
    let poster: NetworkImageView = {
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        return $0
    }(NetworkImageView())
    
    let title: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 2
        //        $0.backgroundColor = .white
        return $0
    }(UILabel())

    let date: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    let genres: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .gray
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        layout()
    }
    
    
    private func layout() {
        poster.pin(to: contentView)
            .left(10)
            .right(10)
            .top(10)
            .height(185)
        title.pin(to: contentView)
            .below(of: poster, aligned: .left)
            .marginTop(2.0)
            .width(poster.frame.width)
            .height(15)
        //        print(poster.frame)
        if countLabelLines(label: title) != 1{
            title.pin(to: contentView)
                .below(of: poster, aligned: .left)
                .marginTop(2.0)
                .width(poster.frame.width)
                .height(30)
        }
        genres.pin(to: contentView)
            .below(of: title, aligned: .left)
            .marginTop(2.0)
            .width(poster.frame.width)
            .height(15)
        date.pin(to: contentView)
            .below(of: genres, aligned: .left)
            .marginTop(2.0)
            .width(poster.frame.width)
            .height(15)
    }
    
    func countLabelLines(label: UILabel) -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        let myText = label.text! as NSString
        
        let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font!], context: nil)
        
        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoSizeThatFits(size, layoutClosure: layout)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension UIView {
    public func pin(to addView: UIView) -> PinLayout<UIView> {
        if !addView.subviews.contains(self) {
            //                DispatchQueue.main.async {
            addView.addSubview(self)
            //                }
        }
        return self.pin
    }
}

extension UICollectionView {
    
    func create<A: CellProtocol>(cell: A.Type, at index: IndexPath) -> A {
        return self.dequeueReusableCell(withReuseIdentifier: cell.name, for: index) as! A
    }
    
    func register<A: CellProtocol>(classXIB: A.Type) {
        let cell = UINib(nibName: classXIB.name, bundle: nil)
        self.register(cell, forCellWithReuseIdentifier: classXIB.name)
    }
    
    func register<A: CellProtocol>(classCell: A.Type) {
        self.register(classCell.self, forCellWithReuseIdentifier: classCell.name)
    }
    
}

extension MainViewController: UICollectionViewDataSource & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.presenter.films[collectionView.tag]!.count > 1{
            return self.presenter.films[collectionView.tag]!.count
        }
        else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.create(cell: MainCollectionViewCell.self, at: indexPath)
        //        print("[DEBUG] index path \(indexPath.row)")
        let film = presenter.films[collectionView.tag]?[indexPath.row]
        var genres = ""
        film?.genreIds.forEach{
            genres += "\(presenter.genres[$0] ?? ""), "
        }
        genres = genres.trimmingCharacters(in: [" ", ","])
        //        print(type(of: film))
        //self.films
        //        print(self.presenter.films[collectionView.tag])
        cell.poster.setURL(URL(string: "https://image.tmdb.org/t/p/w185\(film?.posterPath ?? "")"))
        cell.genres.text = genres
        cell.title.text = film?.title
        let getDateFormatter = DateFormatter()
        getDateFormatter.dateFormat = "yyyy-MM-dd"
        getDateFormatter.calendar = .current
        getDateFormatter.locale = Locale(identifier: "ru_RU")
        getDateFormatter.timeZone = TimeZone(abbreviation: "MSK")
        let printDateFormatter = DateFormatter()
        printDateFormatter.dateFormat = "dd MMMM"
        printDateFormatter.locale = Locale(identifier: "ru_RU")
        printDateFormatter.timeZone = TimeZone(secondsFromGMT: 10800)
        if collectionView.tag == 0 {
            let date = getDateFormatter.date(from: film?.releaseDate ?? "2000-10-21")
            cell.date.text = printDateFormatter.string(from: date!)
//            date(from: "2021-11-11")
        }
        else {
            cell.date.text = nil
        }
        /*
         Дает странную дичь, если выключить интернет, а потом даже если включить (прописывает даты в коллекции, у которой должен быть тэг 1, если указать else, то он передумает так делать)
        */
        //        cell.poster.image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clickedFilm = self.presenter.films[collectionView.tag]![indexPath.row]
        print(clickedFilm.posterPath)
        print(clickedFilm.overview)
        
        let detailsVC = DetailsViewController(film: clickedFilm)
        self.navigationController?.pushViewController(detailsVC, animated: true)
        
        /*let detailcVC = FilmDetailsViewController()
        print(collectionView.tag)
        
        let user = User(email: "wolf@wolf.wolf", favoriteFilms: [])
        let film = FilmDetails(name: "test", genres: [], plot: "wolf", image: "")
        let presenter = FilmDetailsPresenter(view: detailcVC, user: user, film: film)
        detailcVC.presenter = presenter
        //detailcVC.presenter.film = self.presenter.films[collectionView.tag]![indexPath.row]
        //detailcVC.presenter.genres = self.presenter.genres
    }
}

