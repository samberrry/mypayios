//
//  CardCell.swift
//  mypay
//
//  Created by Hessam on 12/22/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var labelCardName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
