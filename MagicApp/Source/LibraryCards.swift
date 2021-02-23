//
//  CollectionCards.swift
//  MagicApp
//
//  Created by Felipe Ferreira on 23/02/21.
//

import Foundation
import UIKit

class libraryCards: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var cardsView: UICollectionView!
    
    override func viewDidLoad() {
        cardsView.delegate = self
        cardsView.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardsView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! customCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click")
        performSegue(withIdentifier: "infoSegue", sender: nil)
    }
    
    
    
    
}


//class favoriteCards: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
//
//    override func viewDidLoad() {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//
//}
