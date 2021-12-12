//
//  MainTableViewCell.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 09.11.2021.
//

import UIKit
import PinLayout
final class MainTableViewCell: UITableViewCell, CellProtocol {
    
    static var name: String {
        return "MainTableViewCell"
    }
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
    
    let collectionView: UICollectionView = {
        $0.isScrollEnabled = true
        $0.backgroundColor = Colors.background2
        $0.register(classCell: MainCollectionViewCell.self)
        $0.showsHorizontalScrollIndicator = false
        return $0
    }(UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init()))
    
    let errorLabel: UILabel = {
        $0.font = UIFont(name: "Helvetica Neue", size: 14)
        $0.textColor = Colors.text
        return $0
    }(UILabel(frame: CGRect.zero))
    
    let refreshButton: UIButton = {
        $0.isHidden = true
        $0.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        $0.setTitleColor(Colors.highlight, for: .normal)
        return $0
    }(UIButton(frame: CGRect.zero))
    
    let indicator: UIActivityIndicatorView = {
        $0.hidesWhenStopped = true
        $0.color = Colors.highlight
        return $0
    }(UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40)))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.background1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        
        collectionView.pin(to: contentView).height(of: self.contentView).all()
        errorLabel.pin(to: contentView).center().sizeToFit()
        refreshButton.pin(to: contentView).below(of: errorLabel).center().sizeToFit()
        indicator.pin(to: contentView).center()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            }
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate
    ) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.reloadData()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoSizeThatFits(size, layoutClosure: layout)
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}

extension UITableView {
    
    func create<A: CellProtocol>(cell: A.Type) -> A {
        self.dequeueReusableCell(withIdentifier: cell.name) as! A
    }
    
    func create<A: CellProtocol>(cell: A.Type, at index: IndexPath) -> A {
        self.dequeueReusableCell(withIdentifier: cell.name, for: index) as! A
    }
    
    func register<A: CellProtocol>(classCell: A.Type) {
        self.register(classCell.self, forCellReuseIdentifier: classCell.name)
    }
    
    func register(nibName name: String, forCellReuseIdentifier identifier: String) {
        let someNib = UINib(nibName: name, bundle: nil)
        self.register(someNib, forCellReuseIdentifier: identifier)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor =  Colors.background1
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 55, height: 40))
        let btn = UIButton(frame: CGRect(x: view.frame.width - 50, y: 0, width: 45, height: 40))
        lbl.font = UIFont(name: "Helvetica Neue Bold", size: 20)
        lbl.textColor = Colors.text
        btn.setTitle("Все", for: .normal)
        btn.tag = section
        btn.addTarget(self, action: #selector(didTapBuuton(sender:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        btn.setTitleColor(Colors.placeholder, for: .normal)
        switch section{
        case 0:
            lbl.text = Headers.upcoming.rawValue
        case 1:
            lbl.text = Headers.inCinema.rawValue
        case 2:
            lbl.text = Headers.popularNow.rawValue
        default:
            lbl.text = Headers.bestFilms.rawValue
        }
        view.addSubview(lbl)
        view.addSubview(btn)
        return view
     }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? MainTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self)
        tableViewCell.collectionViewOffset = self.storedOffsets[indexPath.section] ?? 0
    }
    

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? MainTableViewCell else { return }
        storedOffsets[indexPath.section] = tableViewCell.collectionViewOffset
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.create(cell: MainTableViewCell.self, at: indexPath)
        cell.collectionView.tag = indexPath.section
        cell.refreshButton.addTarget(self, action: #selector(refresh(sender:)), for: .touchUpInside)
        if self.presenter.films[indexPath.section]!.count < 2 && self.presenter.loadIndicator[indexPath.section] == 1 {
            cell.refreshButton.isHidden = false
            cell.errorLabel.text = "Произошла ошибка"
            cell.refreshButton.setTitle("Обновить", for: .normal)
            print(cell.refreshButton.frame)
        }
        else {
            cell.errorLabel.text = ""
            cell.refreshButton.setTitle("", for: .normal)
            cell.refreshButton.isHidden = true
            print(cell.refreshButton.frame)
        }
        
        if self.presenter.loadIndicator[indexPath.section] == 0 && self.presenter.films[indexPath.section]!.count < 2 {
            cell.indicator.startAnimating()
            cell.errorLabel.text = ""
            cell.refreshButton.setTitle("", for: .normal)
            cell.refreshButton.isHidden = true
        }
        else {
            cell.indicator.stopAnimating()
        }
        
        return cell
    }
    
    @objc func didTapBuuton (sender: UIButton){
        self.presenter.didTapButton(tag: sender.tag)
    }
    
    func showVC (tag: Int){
        
        let listView = ListViewController()
        listView.initPresenter(tag: tag)
        listView.presenter.films = self.presenter.films[tag]!
        listView.presenter.totalPages = self.presenter.totalPages[tag]
        listView.presenter.genres = self.presenter.genres
//        listView.presenter = presenter
        switch tag{
        case 0:
            listView.title = Headers.upcoming.rawValue
        case 1:
            listView.title = Headers.inCinema.rawValue
        case 2:
            listView.title = Headers.popularNow.rawValue
        default:
            listView.title = Headers.bestFilms.rawValue
        }
        self.navigationController?.pushViewController(listView, animated: true)
    }
}
