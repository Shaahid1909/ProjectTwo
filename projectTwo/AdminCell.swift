//
//  AdminCell.swift
//  projectTwo
//
//  Created by Admin Mac on 24/02/21.
//

import UIKit

class AdminCell: UITableViewCell {

    @IBOutlet weak var completeLab: UILabel!
    
    @IBOutlet weak var pendingLab: UILabel!
    
    @IBOutlet weak var userLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
