//
//  ViewController.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 25.10.2021.
//

import UIKit
protocol MainViewControllerProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

class MainViewController: UIViewController, MainViewControllerProtocol {
    func success() {
        print(presenter.films!)
    }
    
    func failure(error: Error) {
        print("Ашибка брат")
        print(error)
    }
    var presenter: MainPresenterProtocol!
    var mostPopularCollectionView: UICollectionView!
    var comingSoomCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        presenter = MainPresenter(view: self, networkManager: NetworkManager())
        presenter.getFilms()
        // Do any additional setup after loading the view.
    }

}

//extension MainViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
    
//}

