//
//  SearchViewController.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 14.12.2021.
//

import UIKit

protocol SearchViewControllerProtocol: AnyObject{
    var presenter: SearchPresenterProtocol! { get set }
}

final class SearchViewController: UIViewController, SearchViewControllerProtocol, UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.films.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    let search: CustomTextField = {
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.keyboardType = UIKeyboardType.default
        $0.isUserInteractionEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderWidth = 1.0
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4.0
        $0.layer.borderColor = Colors.highlight.cgColor
        $0.attributedPlaceholder = NSAttributedString(
            string: "Введите запрос",
            attributes: [NSAttributedString.Key.foregroundColor: Colors.placeholder]
        )
        $0.backgroundColor = .gray
        $0.textColor = Colors.text
        $0.font = UIFont(name: "Helvetica Neue", size: 18)
//        $0.clearsOnBeginEditing = true
        $0.clearButtonMode = .whileEditing
        return $0
    }(CustomTextField())
    
    let tableView: UITableView = {
        $0.register(classCell: ListTableViewCell.self)
        return $0
    }(UITableView(frame: CGRect.zero, style: .plain))
    
    var presenter: SearchPresenterProtocol!
    var searchString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure ()
    {
        presenter = SearchPresenter(view: self)
        presenter.output = self
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.text]
        self.title = "Поиск"
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        search.addTarget(self, action: #selector(search(sender:)), for: .editingChanged)
        self.view.addSubview(tableView)
        self.view.addSubview(search)
        self.view.backgroundColor = Colors.background2
        tableView.backgroundColor = Colors.background2
        tableView.separatorColor = Colors.highlight
        tableView.isHidden = true
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        search.pin.width(self.view.frame.width - 20).height(35).top(self.view.pin.safeArea).left().right().margin(10)
        tableView.pin.below(of: search).marginTop(5).width(self.view.frame.width).bottom(self.view.pin.safeArea)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > (contentHeight - scrollView.frame.size.height) {
            presenter.getFilms(query: searchString, scroll: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.create(cell: ListTableViewCell.self, at: indexPath)
        cell.selectionStyle = .none
        let film = presenter.films[indexPath.row]
        var genres = ""
        film.genreIds?.forEach{
            genres += "\(presenter.genres[$0] ?? ""), "
        }
        genres = genres.trimmingCharacters(in: [" ", ","])
        cell.genres.text = genres
        cell.poster.setURL(URL(string: "https://image.tmdb.org/t/p/w185\(film.posterPath ?? "")"))
        cell.title.text = film.title
        if film.releaseDate != ""{
            let date = DateFormatter.formDate(text: film.releaseDate!)
            cell.date.text = DateFormatter.formString(date: date!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clickedFilm = self.presenter.films[indexPath.row]
        let detailsVC = DetailsViewController(film: clickedFilm)
        
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        backItem.tintColor = Colors.highlight
        navigationItem.backBarButtonItem = backItem
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    @objc func search(sender: UITextField) {
        searchString = sender.text
        if searchString.count == 0{
            presenter.films.removeAll()
            tableView.reloadData()
            tableView.isHidden = true
        }
        else {
            presenter.getFilms(query: searchString, scroll: false)
            
        }
    }
}

extension SearchViewController: SearchPresenterOutput{
    func success() {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            UIView.transition(with: self.tableView,
                              duration: 0.35,
                              options: .beginFromCurrentState,
                              animations: { self.tableView.reloadData() })
        }
    }
    
    func failure() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
