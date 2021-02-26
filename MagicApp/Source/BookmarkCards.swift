//
//  BookmarkCards.swift
//  MagicApp
//
//  Created by Felipe Ferreira on 23/02/21.
//

import Foundation
import UIKit
import CoreData

class bookmarkCads: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate{
    
    var cards:[NSManagedObject] = []
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
        
        //Core data
        readEntries(entity: "CardEntity")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readEntries(entity: "CardEntity")
        cardsView.reloadData()
    }
    
    // MARK: Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardsView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! customCell
        let card = cards[indexPath.row]
        
        cell.lblName.text = card.value(forKey: "name") as! String
        
        if card.value(forKey: "url") != nil  {
            cell.imgCard.load(url: URL(string: (card.value(forKey: "url"))! as! String)!)
        }
        
        return cell
    }
    
    func readEntries(entity: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CardEntity")
        
        do {
             cards = try managedContext.fetch(fetchRequest)
                } catch let error as NSError {
            print("Não foi possível carregar os dados. \(error), \(error.userInfo)")
            }
    }
    
    
    
}
