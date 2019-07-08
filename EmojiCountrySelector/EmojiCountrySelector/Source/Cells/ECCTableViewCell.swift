//
//  ECCTableViewCell.swift
//  EmojiCountryCode
//
//  Created by zubair on 7/5/19.
//  Copyright © 2019 zubair. All rights reserved.
//

import UIKit

class ECCTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func populateCell(with country:Country, textColor:UIColor, font:UIFont) -> Void {
        nameLabel.text = country.name
        flagLabel.text = country.flagEmoji
        codeLabel.text = country.phoneCode
        
        nameLabel.textColor = textColor
        flagLabel.textColor = textColor
        codeLabel.textColor = textColor
        
        nameLabel.font = font
        flagLabel.font = font
        codeLabel.font = font
    }

}
