//
//  MainMenuCell.swift
//  mypay
//
//  Created by Hessam on 12/19/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import UIKit

class MainMenuCell: UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var decription: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
