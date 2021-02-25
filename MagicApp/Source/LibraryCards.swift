//
//  CollectionCards.swift
//  MagicApp
//
//  Created by Felipe Ferreira on 23/02/21.
//

import Foundation
import UIKit

class libraryCards: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var cardsView: UICollectionView!
    @IBOutlet weak var txtName: UITextField!
    var library = Cards()
    var response = HTTPURLResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Request
        getCards()
        
        //Collection delegation
        cardsView.delegate = self
        cardsView.dataSource = self
        
        //Visual
        cardsView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        if let button = txtName.value(forKey: "clearButton") as? UIButton {
                  button.tintColor = .white
                  button.setImage(UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
                }
        
        //Functionalities
        txtName.delegate = self
        
        
    }
    
    // MARK: Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    // MARK: Collection View
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
    
    
    // MARK: API REQUESTS
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
    
    func getCardByName(name: String){
        
        let urlName = "https://api.magicthegathering.io/v1/cards?name=\(name)"
        
        // Allowing spaces
        let urlValidString = urlName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        // Making request with the allowed characters
        var request = URLRequest(url: URL(string: urlValidString!)!)
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
    
    // MARK: Keyboard related
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        getCardByName(name: txtName.text!)
        return false
    }
    
    @IBAction func bttLimpar(_ sender: Any) {
        txtName.text = ""
        getCards()
    }
    
    
}

