//
//  NetworkImage.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 11.11.2021.
//

import UIKit
import Kingfisher

final class NetworkImageView: UIImageView {
    func setURL(_ url: URL?) {
        kf.setImage(with: url, placeholder: nil, options: nil, completionHandler: nil)
    }
}
