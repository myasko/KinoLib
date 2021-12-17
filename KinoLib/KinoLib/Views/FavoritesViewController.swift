//
//  FavoritesViewController.swift
//  KinoLib
//
//  Created by Георгий Бутров on 17.12.2021.
//

import UIKit

protocol FavoritesViewControllerProtocol: AnyObject{
    var presenter: FavoritesPresenterProtocol! { get set }
}

class FavoritesViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, FavoritesViewControllerProtocol, FavoritesPresenterOutput {
    
    var presenter: FavoritesPresenterProtocol!
    
    func success() {
        return
    }
    
    func failure() {
        return
    }
    
    var filmsTableView = UITableView()
    
    required init() {
        super.init(nibName: nil, bundle: nil)
        
        self.presenter = FavoritesPresenter(view: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        filmsTableView.frame = view.bounds
    }
    
    func updateData() {
        presenter.loadFilms() {
            err in
            
            self.presenter.getFilms()
            
            self.filmsTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateData()
    }
    
    func setUpUI() {
        presenter.output = self
        
        view.backgroundColor = Colors.background2
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.text]
        self.title = "Избранное"
        
        view.addSubview(filmsTableView)
        filmsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        filmsTableView.delegate = self
        filmsTableView.dataSource = self
        
        filmsTableView.backgroundColor = Colors.background2
        filmsTableView.separatorColor = Colors.highlight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.filmFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filmsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let film = presenter.filmFavorites[indexPath.row]
        
        cell.textLabel?.text = film.title
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = Colors.background2
        
        return cell
        
//        let cell = tableView.create(cell: ListTableViewCell.self, at: indexPath)
//        cell.selectionStyle = .none
//        let film = presenter.films[indexPath.row]
//        if let poster = film.posterPath {
//            cell.poster.setURL(URL(string: "https://image.tmdb.org/t/p/w185\(poster)"))
//        }
//        else {
//            cell.poster.image = UIImage(named: "noposter")
//        }
//        cell.title.text = film.title
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        filmsTableView.deselectRow(at: indexPath, animated: true)
        
        let clickedFilm = self.presenter.films[indexPath.row]
        let detailsVC = DetailsViewController(film: clickedFilm, genres: [""])

        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        backItem.tintColor = Colors.highlight
        navigationItem.backBarButtonItem = backItem

        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

