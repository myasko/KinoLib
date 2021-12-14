//
//  NetworkImageView.swift
//  YoulaLight
//
//  Created by Максим on 18.11.2021.
//

import UIKit
import Kingfisher

final class NetworkImageView: UIImageView {
    
    func setURL(_ url: URL?) {
        kf.setImage(with: url, placeholder: nil, options: nil, completionHandler: nil)
        
//        guard let url = url else {
//            image = nil
//            return
//        }
//
//        DispatchQueue.global().async {
//            var image: UIImage?
//
//            if let data = try? Data(contentsOf: url) {
//                image = UIImage(data: data)
//            }
//
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }
    }
}
