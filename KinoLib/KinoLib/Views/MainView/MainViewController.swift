//
//  ViewController.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 25.10.2021.
//

import UIKit
import PinLayout

protocol MainViewControllerProtocol: AnyObject{
    var tableView: UITableView {get}
    var presenter: MainPresenterProtocol! { get set }
}

class MainViewController: UIViewController, UINavigationControllerDelegate, MainViewControllerProtocol  {
    
    enum Headers: String {
        case upcoming = "Скоро в кино"
        case inCinema = "Сейчас в кино"
        case popularNow = "Популярно сейчас"
        case bestFilms = "Лучшие фильмы"
    }
    
    var storedOffsets = [Int: CGFloat]()
    var presenter: MainPresenterProtocol!
    var mostPopularCollectionView: UICollectionView!
    var comingSoomCollectionView: UICollectionView!
    
    let tableView: UITableView = {
        $0.register(classCell: MainTableViewCell.self)
        return $0
    }(UITableView(frame: CGRect.zero, style: .grouped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        configure()
        presenter = MainPresenter(view: self)
        self.presenter.loadData()
        presenter.output = self
//        self.presenter.genresDictfunc()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.width(self.view.frame.width).all(self.view.pin.safeArea)
    }
    
    func configure(){
        self.navigationController?.delegate = self
        self.title = "Главная"
        // navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        self.view.addSubview(tableView)
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
        return 260
    } else {
        return 245
      }
    }
}

extension MainViewController: MainPresenterOutput{
    func success() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func failure() {
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }
    
    
}

protocol CellProtocol: UIView {
    static var name: String { get }
}





