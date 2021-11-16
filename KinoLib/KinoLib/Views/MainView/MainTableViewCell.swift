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
//        collectionView.reloadData()
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forSection section: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = section
        collectionView.reloadData()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoSizeThatFits(size, layoutClosure: layout)
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
        lbl.font = UIFont.systemFont(ofSize: 20)
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
        return view
     }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? MainTableViewCell else { return }
        
        DispatchQueue.main.async {
            tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forSection: indexPath.section)
            tableViewCell.collectionViewOffset = self.storedOffsets[indexPath.section] ?? 0
        }
//        print(tableViewCell.collectionView.contentSize)
        
//        print("now offset \(tableViewCell.collectionViewOffset)")
    }
    

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? MainTableViewCell else { return }
        storedOffsets[indexPath.section] = tableViewCell.collectionViewOffset
//        print("will offset \(tableViewCell.collectionViewOffset)")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.create(cell: MainTableViewCell.self, at: indexPath)
        return cell
    }
    

}
