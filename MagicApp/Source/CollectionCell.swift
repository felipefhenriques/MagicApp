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
        imgCard.layer.cornerRadius = 12
    }
    
    override func prepareForReuse() {
        imgCard.image = UIImage(named: "Imagenotfound")
    }
}

//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}

extension UIImageView {
    func load(url: URL, completionHadler: @escaping (_ image: Data) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                completionHadler(data)
                //self.image = UIImage(data: data)
            }
        }.resume()
    }
}
