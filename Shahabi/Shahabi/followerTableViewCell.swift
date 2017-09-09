//
//  followerTableViewCell.swift
//

import UIKit

class followerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var followerImage: UIImageView!
    
    @IBOutlet weak var followerName: UILabel!
    
    @IBOutlet weak var followerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

