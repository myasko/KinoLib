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
    func showVC(tag: Int)
}

class MainViewController: UIViewController, UINavigationControllerDelegate, MainViewControllerProtocol  {

    enum Headers: String {
        case upcoming = "Скоро в кино"
        case inCinema = "Сейчас в кино"
        case popularNow = "Популярно сейчас"
        case bestFilms = "Лучшие фильмы"
    }
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Colors.highlight
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()

    var storedOffsets = [Int: CGFloat]()
    var presenter: MainPresenterProtocol!

    let tableView: UITableView = {
        $0.register(classCell: MainTableViewCell.self)
        return $0
    }(UITableView(frame: CGRect.zero, style: .grouped))

    @objc func refresh(sender: Any){
        if let sender = sender as? UIRefreshControl {
            sender.endRefreshing()
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.presenter.loadData()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refreshControl
        configure()
        presenter = MainPresenter(view: self)
        self.presenter.loadData()
        presenter.output = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.width(self.view.frame.width).all(self.view.pin.safeArea)
        self.view.backgroundColor = Colors.background2
        tableView.backgroundColor = Colors.background2
        self.navigationController?.navigationBar.barTintColor = Colors.background2
    }

    func configure(){
        
//        self.navigationController?.delegate = self
        self.title = "Главная"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.text]
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.contentInsetAdjustmentBehavior = .never
        self.navigationItem.hidesBackButton = true
        self.view.addSubview(tableView)

        self.tableView.separatorStyle = .none
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
            UIView.transition(with: self.tableView,
                              duration: 0.35,
                              options: .beginFromCurrentState,
                              animations: { self.tableView.reloadData() })
        }

    }

    func failure() {
        let alert = UIAlertController(title: "Ошибка", message: "Произошла сетевая ошибка во время загрузки данных. Повторите позже", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }


}

protocol CellProtocol: UIView {
    static var name: String { get }
}
