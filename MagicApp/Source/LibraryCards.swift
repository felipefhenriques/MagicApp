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
    @IBOutlet weak var ActIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblNotFoundCard: UILabel!
    
    var pageCount = 1
    var library = Cards()
    var cardsVersion = [Card()]
    var response = HTTPURLResponse()
    let imageNotFound = UIImage(named: "Imagenotfound")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Request
        getCards()
        
        //Collection delegation
        cardsView.delegate = self
        cardsView.dataSource = self
        
        //Visual
        lblNotFoundCard.isHidden = true
        cardsView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        if let button = txtName.value(forKey: "clearButton") as? UIButton {
                  button.tintColor = .white
                  button.setImage(UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
                }
        
        //Functionalities
        txtName.delegate = self
        //btnBackward.isEnabled = false
        
    }
    
    // MARK: Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoSegue"{
            
            let cardInfo:cardInfo = segue.destination as! cardInfo
            cardInfo.firstCard = self.library.cards![sender as! Int]
        }
    }
    
    // MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return library.cards?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardsView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! customCell
        
        cell.lblName.text = library.cards?[indexPath.item].name
        
        //MARK: Logica de carregar as cartas
        if library.cards?[indexPath.item].imageUrl != nil {
            if self.library.cards?[indexPath.item].image == nil {
                cell.imgCard.load(url: URL(string: (library.cards?[indexPath.item].imageUrl)!)!) {(data) in
                    self.library.cards?[indexPath.item].image = data
                    cell.imgCard.image = UIImage(data: (self.library.cards?[indexPath.item].image)!)
                }
            }
            else{
                cell.imgCard.image = UIImage(data: (self.library.cards?[indexPath.item].image)!)
            }
            
        }
        ActIndicator.stopAnimating()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "infoSegue", sender: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return cardsView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
    }
    
    
    // MARK: API REQUESTS
    func getCards(){
        
        ActIndicator.startAnimating()
        
        var request = URLRequest(url: URL(string: "https://api.magicthegathering.io/v1/cards")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            
            do {
                self.library = try JSONDecoder().decode(Cards.self, from: data)
                self.response = response as! HTTPURLResponse
                DispatchQueue.main.async {
                    self.cardsView.reloadData()
                    self.notFoudnCard()
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
                self.notFoudnCard()
            }
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }.resume()
    }
    
    
    func getPage(page: Int){
        let urlPage = pageCount + page
        
        
        ActIndicator.startAnimating()
        
        var request = URLRequest(url: URL(string: "https://api.magicthegathering.io/v1/cards?page=\(urlPage)")!)
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
        
        cardsView.setContentOffset(.zero, animated: true)
        cardsView.reloadData()
    }
    
    func notFoudnCard(){
        if self.library.cards?.count == 0 {
            lblNotFoundCard.isHidden = false
            cardsView.isHidden = true
        }
        else {
            lblNotFoundCard.isHidden = true
            cardsView.isHidden = false
        }
    }
    
    // MARK: Pages
    
    func pageController()-> Int{
        let page = response.allHeaderFields["Total-Count"] as? Int
        return page!/100
    }
    
    @IBAction func fowardPage(_ sender: Any) {
        getPage(page: +1)
        pageCount+=1
    }
    
    @IBAction func backwardPage(_ sender: Any) {
        if pageCount != 1{
            getPage(page: -1)
            pageCount-=1
        }
    }
    
    
    // MARK: Keyboard related
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        getCardByName(name: txtName.text!)
        return false
    }
    
    
}


