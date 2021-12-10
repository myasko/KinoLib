//
//  ListViewController.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 08.12.2021.
//

import UIKit

protocol ListViewControllerProtocol: AnyObject{
    var presenter: ListPresenterProtocol! { get set }
}

final class ListViewController: UIViewController, ListViewControllerProtocol, UITableViewDataSource, UITableViewDelegate {
    var presenter: ListPresenterProtocol!
    func initPresenter(tag: Int){
        presenter = ListPresenter(view: self, tag: tag)
    }
    let tableView: UITableView = {
        $0.register(classCell: MainTableViewCell.self)
        return $0
    }(UITableView(frame: CGRect.zero, style: .plain))
    
    let label: UILabel = {
        $0.font = UIFont(name: "Helvetica Neue Bold", size: 14)
        $0.textColor = Colors.text
        return $0
    }(UILabel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(classCell: ListTableViewCell.self)
        configure()
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func checkLabel (){
        DispatchQueue.main.async {
            if self.presenter.films.count < 2 {
                self.label.text = "Произошла ошибка во время загрузки данных"
                self.label.pin(to: self.view).center().sizeToFit()
            }
            else {
                self.label.text = ""
            }
        }
    }
    func configure(){
        checkLabel()
        navigationController?.navigationBar.tintColor = Colors.highlight
        presenter.output = self
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.contentInsetAdjustmentBehavior = .never
        self.view.addSubview(tableView)
        self.view.addSubview(label)
        self.view.backgroundColor = Colors.background2
        tableView.backgroundColor = Colors.background2
        tableView.separatorColor = Colors.highlight 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.width(self.view.frame.width).all(self.view.pin.safeArea)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.films.count > 1{
            return presenter.films.count
        }
        else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.create(cell: ListTableViewCell.self, at: indexPath)
        let film = presenter.films[indexPath.row]
        var genres = ""
        film.genreIds?.forEach{
            genres += "\(presenter.genres[$0] ?? ""), "
        }
        genres = genres.trimmingCharacters(in: [" ", ","])
        cell.genres.text = genres
        cell.poster.setURL(URL(string: "https://image.tmdb.org/t/p/w185\(film.posterPath ?? "")"))
        cell.title.text = film.title
        
        
        if presenter.tag == 0 {
            let date = DateFormatter.formDate(text: film.releaseDate ?? "")
            cell.date.text = DateFormatter.formString(date: date!)
        }
        
        else {
            cell.date.text = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
//        print("DEBUG OFFSET \(offsetY)")
//        print("DEBUG height \(contentHeight)")
//        print(scrollView.frame.size.height)
        if offsetY > (contentHeight - scrollView.frame.size.height) {
            presenter.getFilms()
//            print("LOAD")
        }
    }
            
            
    // MARK: - Table view data source
}

extension ListViewController: ListPresenterOutput{
    func success() {
        DispatchQueue.main.async {
            UIView.transition(with: self.tableView,
                              duration: 0.35,
                              options: .beginFromCurrentState,
                              animations: { self.tableView.reloadData() })
        }
        checkLabel()
    }
    
    func failure() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        checkLabel()
    }
    
}
