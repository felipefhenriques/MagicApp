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
    var managedObjContext: NSManagedObjectContext!
    @IBOutlet weak var btnExit: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblName: UILabel!
    var cardsVersion = [Card()]
    var indexCard:Int!
    override func viewDidLoad() {
        lblName.text = cardsVersion[indexCard].name

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
        
        for i in 0...cards.count-1{
            print(cards[i].value(forKey: "name"))
        }
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
    
    
}


