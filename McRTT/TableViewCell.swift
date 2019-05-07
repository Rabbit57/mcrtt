//
//  TableViewCell.swift
//  McRTT
//
//  Created by Egor Orlov on 03/04/2019.
//  Copyright © 2019 XorMagic. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var roundTrip: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
