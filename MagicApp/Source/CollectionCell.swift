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
    }
}
