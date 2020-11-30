//
//  HomeTableCellTableViewCell.swift
//  MC1
//
//  Created by Alvian Gozali on 08/04/20.
//  Copyright © 2020 Alvian Gozali. All rights reserved.
//

import UIKit

class HomeTableCell: UITableViewCell {
    
    @IBOutlet weak var approxTimeLbl: UILabel!
    @IBOutlet weak var activityTitleLbl: UILabel!
    @IBOutlet weak var deadlineLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
