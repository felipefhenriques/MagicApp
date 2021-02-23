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
    var library = Cards()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCards()
        cardsView.delegate = self
        cardsView.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return library.cards?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardsView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! customCell
        cell.lblName.text = library.cards?[indexPath.item].name
        if library.cards?[indexPath.item].imageUrl != nil {
            cell.imgCard.load(url: URL(string: (library.cards?[indexPath.item].imageUrl)!)!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click")
        performSegue(withIdentifier: "infoSegue", sender: nil)
    }
    
    
    func getCards(){
        var request = URLRequest(url: URL(string: "https://api.magicthegathering.io/v1/cards")!)
//        request.setValue("2", forHTTPHeaderField: "Page-Size")
//        request.setValue("2", forHTTPHeaderField: "Count")
//        request.setValue("31090", forHTTPHeaderField: "Total-Count")
//        request.setValue("5000", forHTTPHeaderField: "Ratelimit-Limit")
//        request.setValue("4999", forHTTPHeaderField: "Ratelimit-Remaining")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            
            do {
                self.library = try JSONDecoder().decode(Cards.self, from: data)
                DispatchQueue.main.async {
                    self.cardsView.reloadData()
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }.resume()
    }
    
}

