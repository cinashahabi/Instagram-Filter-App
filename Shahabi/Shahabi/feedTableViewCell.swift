//
//  feedTableViewCell.swift
//

import UIKit

class feedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var follower_user_pic: UIImageView!
    
    @IBOutlet weak var follower_user_name: UILabel!
    
    @IBOutlet weak var follower_photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

