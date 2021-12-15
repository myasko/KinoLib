//
//  ListTableViewCell.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 08.12.2021.
//

import UIKit

final class ListTableViewCell: UITableViewCell, CellProtocol {
    
    static var name: String {return "ListTableViewCell"}
    
    let poster: NetworkImageView = {
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        return $0
    }(NetworkImageView())
    
    let title: UILabel = {
        $0.font = UIFont(name: "Helvetica Neue Bold", size: 18)
        $0.textColor = Colors.text
        $0.textAlignment = .left
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    let date: UILabel = {
        $0.font = UIFont(name: "Helvetica Neue", size: 14)
        $0.textColor = Colors.text
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    let genres: UILabel = {
        $0.font = UIFont(name: "Helvetica Neue", size: 14)
        $0.textColor = Colors.text
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.background2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = Colors.background2
        layout()
    }
    
    
    private func layout() {
        poster.pin(to: contentView)
            .left(5)
            .right(5)
            .top(5)
            .height(100)
            .width(66)
        title.pin(to: contentView)
            .right(of: poster)
            .marginHorizontal(10)
            .top(20)
            .width(contentView.frame.width - poster.frame.width - 5)
            .height(20)
        genres.pin(to: contentView)
            .below(of: title, aligned: .left)
            .marginTop(1.0)
            .width(contentView.frame.width - poster.frame.width - 5)
            .height(15)
        date.pin(to: contentView)
            .below(of: genres, aligned: .left)
            .marginTop(2.0)
            .width(contentView.frame.width - poster.frame.width - 5)
            .height(15)
    }
    
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoSizeThatFits(size, layoutClosure: layout)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
