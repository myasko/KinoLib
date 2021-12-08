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
    var films = [Int]()
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
    
    let collectionView: UICollectionView = {
        $0.isScrollEnabled = true
        $0.register(classCell: MainCollectionViewCell.self)
        $0.showsHorizontalScrollIndicator = false
        return $0
    }(UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init()))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
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
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.itemSize = CGSize(width: 150.5, height: collectionView.frame.height)
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
        view.backgroundColor =  UIColor(red: 0.1507387459, green: 0.3653766513, blue: 1, alpha: 1)
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 55, height: 40))
        let btn = UIButton(frame: CGRect(x: view.frame.width - 50, y: 0, width: 45, height: 40))
        lbl.font = UIFont(name: "Helvetica Neue Bold", size: 20)
        lbl.textColor = .white
        btn.setTitle("Все", for: .normal)
        btn.tag = section
        btn.addTarget(self, action: #selector(didTapBuuton(sender:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        btn.setTitleColor(.lightGray, for: .normal)
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
        return cell
    }
    
    @objc func didTapBuuton (sender: UIButton){
        self.presenter.didTapButton(tag: sender.tag)
    }
    
    func showVC (tag: Int){
        
        let listView = ListViewController()
        let presenter = ListPresenter(view: listView, tag: tag)
        presenter.films = self.presenter.films[tag]
        presenter.genres = self.presenter.genres
        listView.presenter = presenter
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
