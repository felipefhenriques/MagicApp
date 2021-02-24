//
//  CardInfo.swift
//  MagicApp
//
//  Created by Felipe Ferreira on 23/02/21.
//

import Foundation
import UIKit

class cardInfo: UIViewController{
    
    @IBOutlet weak var btnExit: UIButton!
    
    override func viewDidLoad() {
        
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
    
}
