import Foundation
import UIKit

class InstagramFollower {
    
    // Username
    let username: String
    
    // Instagram ID 
    let instagramID: String
    
    // Profile Picture 
    let profile_picture: String
    
    // View?
    var canView: Bool
    
    init(username: String, id: String, link_to_photo: String) {
        self.username = username
        self.instagramID = id
        self.profile_picture = link_to_photo
        self.canView = true
    }
    
}
