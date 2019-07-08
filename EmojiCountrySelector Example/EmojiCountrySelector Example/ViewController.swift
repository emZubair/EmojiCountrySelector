//
//  ViewController.swift
//  EmojiCountrySelector Example
//
//  Created by zubair on 7/8/19.
//  Copyright © 2019 zubair. All rights reserved.
//

import UIKit
import EmojiCountrySelector

class ViewController: UIViewController {

    @IBOutlet weak var textfield: ECCCountryPickerTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.set(picker: self, from: self)
        // Do any additional setup after loading the view.
        
    }

}

extension ViewController: ECCCountryPickerDelegate {
    func didSelectCountry(country: Country) {
    }
    
}


