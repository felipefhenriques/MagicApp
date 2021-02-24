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
    @IBOutlet weak var backgroundPattern: UIImageView!
    var library = Cards()
    var response = HTTPURLResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardsView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        getCards()
        cardsView.delegate = self
        cardsView.dataSource = self
        cardsView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        
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
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            
            do {
                self.library = try JSONDecoder().decode(Cards.self, from: data)
                self.response = response as! HTTPURLResponse
                DispatchQueue.main.async {
                    self.cardsView.reloadData()
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }.resume()
    }
    
}

