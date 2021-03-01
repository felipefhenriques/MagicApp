//
//  CardInfo.swift
//  MagicApp
//
//  Created by Felipe Ferreira on 23/02/21.
//

import Foundation
import UIKit
import CoreData

class cardInfo: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
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
    @IBOutlet weak var tableViewDetails: UITableView!
    var tbvTitles = ["", "", "", ""]
    
    //MARK: Scroll
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: ActIndicator
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    //MARK: VARs
    var managedObjContext: NSManagedObjectContext!
    var cardsVersion = [Card()]
    var indexCard:Int!
    var firstCard = Card()
    var savedCard:Bool!
    
    
    //MARK: Override
    override func viewDidLoad() {
        scrollView.isHidden = true
        actIndicator.startAnimating()
        getCardByVersion(name: firstCard.name!)
        tableViewDetails.delegate = self
        tableViewDetails.dataSource = self
        

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
    
    
    
    //Mark: IBAction
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
    
    @IBAction func btnNextAction(_ sender: Any) {
        changeVersion(1)
    }
    @IBAction func btnPrevAction(_ sender: Any) {
        changeVersion(-1)
    }
    
    //MARK: FUNC CoreData
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
        
        let index = cards.firstIndex(where: {$0.value(forKey: "idCard") as! String == String(cardsVersion[indexCard].id!)})
        
        if index != nil {
            btnSave.setImage(UIImage(systemName: "bookmark.circle.fill"), for: .normal)
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
    
    //MARK: FUNC API
    
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
    
    //FUNC LoadItems
    func loadItems(){
        lblName.text = cardsVersion[indexCard].name
        lblVersion.text = "\(cardsVersion[indexCard].set ?? "") - \(cardsVersion[indexCard].setName ?? "")"
        
        if cardsVersion[indexCard].imageUrl != nil {
            self.imgCard.load(url: URL(string: cardsVersion[indexCard].imageUrl!)!)
        }
        else{
            self.imgCard.image = UIImage(named: "Imagenotfound")
        }
        
        lblDescription.text = cardsVersion[indexCard].text
        
        tbvTitles[0] = "Mana Cost: \(cardsVersion[indexCard].manaCost ?? "")"
        
        tbvTitles[1] = "Type: \(cardsVersion[indexCard].type ?? "")"
        
        tbvTitles[2] = "Rarity: \(cardsVersion[indexCard].rarity ?? "")"
        
        tbvTitles[3] = "Artist: \(cardsVersion[indexCard].artist ?? "")"
        
        
        
        if indexCard == 0 {
            btnPrev.isEnabled = false
        }
        else {
            btnPrev.isEnabled = true
        }
        
        if indexCard == cardsVersion.count - 1{
            btnNext.isEnabled = false
        }
        else{
            btnNext.isEnabled = true
        }
        print(cardsVersion[indexCard].set)
        tableViewDetails.reloadData()
        actIndicator.stopAnimating()
        scrollView.isHidden = false
    }
    
    func changeVersion(_ value: Int){
        indexCard = indexCard + value
        loadItems()
    }
    
    //MARK: FUNC TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tbvTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newCell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "tbvCell")! as! TableViewCell
        
        newCell.lblText.text = "\(tbvTitles[indexPath.item])"
        
        return newCell
    }
    
    
    
}

