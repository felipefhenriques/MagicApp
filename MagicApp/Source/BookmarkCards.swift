//
//  FavoriteCards.swift
//  MagicApp
//
//  Created by Felipe Ferreira on 23/02/21.
//

import Foundation
import UIKit

class bookmarkCads: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var cardsView: UICollectionView!
    
    override func viewDidLoad() {
        //Collection delegation
        cardsView.delegate = self
        cardsView.dataSource = self
        
        //Visual
        cardsView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        if let button = txtName.value(forKey: "clearButton") as? UIButton {
                  button.tintColor = .white
                  button.setImage(UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
                }
    }
    
    // MARK: Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardsView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! customCell
        return cell
    }
    
    
}
