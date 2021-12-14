//
//  MovieTableViewCell.swift
//  KinoLib
//
//  Created by Максим on 18.11.2021.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImage: NetworkImageView!
    @IBOutlet weak var movieGenre: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        movieImage.contentMode = .scaleToFill
        movieImage.layer.cornerRadius = 8
        movieImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with favoriteMovie: FavoriteMovie) {
        movieTitle.text = favoriteMovie.title
        movieGenre.text = favoriteMovie.genre
        movieImage.setURL(favoriteMovie.imageUrl)
    }

}
