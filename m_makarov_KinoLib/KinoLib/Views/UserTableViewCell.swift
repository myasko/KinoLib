//
//  UserTableViewCell.swift
//  KinoLib
//
//  Created by Максим on 18.11.2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: NetworkImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImageView.contentMode = .scaleToFill
        userImageView.layer.cornerRadius = 8
        userImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
