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

class ListViewController: UITableViewController, ListViewControllerProtocol {
    
    var presenter: ListPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(classCell: ListTableViewCell.self)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.films.count > 1{
            return presenter.films.count
        }
        else{
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.create(cell: ListTableViewCell.self, at: indexPath)
        let film = presenter.films[indexPath.row]
        var genres = ""
        film.genreIds.forEach{
            genres += "\(presenter.genres[$0] ?? ""), "
        }
        genres = genres.trimmingCharacters(in: [" ", ","])
        cell.genres.text = genres
        cell.poster.setURL(URL(string: "https://image.tmdb.org/t/p/w185\(film.posterPath)"))
        cell.title.text = film.title
        
        
        if presenter.tag == 0 {
            let date = DateFormatter.formDate(text: film.releaseDate)
            cell.date.text = DateFormatter.formString(date: date!)
        }
        
        else {
            cell.date.text = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    // MARK: - Table view data source
}
