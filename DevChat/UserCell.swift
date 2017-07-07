//
//  UserCell.swift
//  DevChat
//
//  Created by the Luckiest on 7/5/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var firstName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setCheckmark(selected: false)
    }
    
    func updateUI(user: User) {
        self.firstName.text = user.firstName
    }
    
    func setCheckmark(selected: Bool) {
        let imageStr = isSelected ? "messageindicatorchecked1" : "messageindicator1"
        self.accessoryView = UIImageView(image: UIImage(named: imageStr))
    }

}
