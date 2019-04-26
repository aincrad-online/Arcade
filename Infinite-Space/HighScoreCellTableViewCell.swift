//
//  HighScoreCellTableViewCell.swift
//  Infinite-Space
//
//  Created by Komlan Attiogbe on 4/25/19.
//  Copyright © 2019 aincrad-online. All rights reserved.
//

import UIKit

class HighScoreCellTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var highScoreLabel: UITextField!
    
    @IBOutlet weak var userNameStatic: UITextField!
    @IBOutlet weak var scoreStatic: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
