//
//  CardInfo.swift
//  MagicApp
//
//  Created by Felipe Ferreira on 23/02/21.
//

import Foundation
import UIKit
import CoreData

class cardInfo: UIViewController{
    
    //MARK: BTNs
    @IBOutlet weak var btnExit: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK: LBLs
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    //MARK: IMG
    @IBOutlet weak var imgCard: UIImageView!
    
    //MARK: TableView
    @IBOutlet weak var tbvwDetails: UITableView!
    
    //MARK: Scroll
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: ActIndicator
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    //MARK: VARs
    var managedObjContext: NSManagedObjectContext!
    var cardsVersion = [Card()]
    var indexCard:Int!
    var firstCard = Card()
    
    
    
    override func viewDidLoad() {
        scrollView.isHidden = true
        actIndicator.startAnimating()
        getCardByVersion(name: firstCard.name!)
        

        //Necessario para o NSManagedObjectContext não retornar nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjContext = appDelegate.persistentContainer.viewContext
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBAction func exitAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveCard(_ sender: Any) {
        saveCard()
    }
    
    @IBAction func printarCarta(_ sender: Any) {
        readEntries(entity: "CardEntity")
    }
    
    @IBAction func apagarEntradas(_ sender: Any) {
        deleteData()
    }
    
    
    
    func saveCard(){
        let entityDescription = NSEntityDescription.entity(forEntityName: "CardEntity", in: self.managedObjContext)
        
        let managedObj = NSManagedObject(entity: entityDescription!, insertInto: self.managedObjContext)
        
        managedObj.setValue(cardsVersion[indexCard].id, forKey: "idCard")
        managedObj.setValue(cardsVersion[indexCard].name, forKey: "name")
        managedObj.setValue(cardsVersion[indexCard].imageUrl, forKey: "url")
        
        do {
            try managedObjContext.save()
        } catch let error as NSError {
            print("Não foi possível salvar a entrada \(error.description)")
        }
        
    }
    
    func readEntries(entity: String){
        var cards:[NSManagedObject] = []
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
        
        if cards.count > 0 {
            for i in 0...cards.count-1{
                print(cards[i].value(forKey: "name"))
            }
        }
        
        
        loadItems()
    }
    
    func deleteData(){
        
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CardEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }
    }
    
    func getCardByVersion(name: String){
        
        let urlName = "https://api.magicthegathering.io/v1/cards?name=\(name)"
        
        let urlValidString = urlName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        var request = URLRequest(url: URL(string: urlValidString!)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let cards = try JSONDecoder().decode(Cards.self, from: data)
                self.cardsVersion = cards.cards!
                DispatchQueue.main.async { [self] in
                    self.indexCard = self.cardsVersion.firstIndex(where: {$0.id == self.firstCard.id})
                    lblName.text = self.cardsVersion[indexCard].name
                    readEntries(entity: "CardEntity")
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func loadItems(){
        lblName.text = cardsVersion[indexCard].name
        lblVersion.text = "\(cardsVersion[indexCard].set ?? "") - \(cardsVersion[indexCard].setName ?? "")"
        if cardsVersion[indexCard].imageUrl != nil {
            self.imgCard.load(url: URL(string: cardsVersion[indexCard].imageUrl!)!)
        }
        
        lblDescription.text = cardsVersion[indexCard].text
        actIndicator.stopAnimating()
        scrollView.isHidden = false
    }
    
    
}

