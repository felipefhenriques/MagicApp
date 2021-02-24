//
//  CollectionCell.swift
//  MagicApp
//
//  Created by Felipe Ferreira on 23/02/21.
//

import Foundation
import UIKit

class customCell: UICollectionViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCard: UIImageView!
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 15
        imgCard.layer.cornerRadius = 15
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
