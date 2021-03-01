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
    func load(url: URL) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            
            do {
                DispatchQueue.main.async {
                    self.image = try? UIImage(data: data)
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }.resume()
    }
}
