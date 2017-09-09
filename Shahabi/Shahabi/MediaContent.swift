import Foundation
import UIKit

class MediaContent {
    
    // Media ID
    let mediaID: String
    
    // Media Photo
    let media_picture: String
    
    // Follower 
    let follower_name: String
    
    // Follower Photo
    let follower_picture: String
    
    init(id: String, link_to_photo: String, name: String, follower_link: String) {
        self.mediaID = id
        self.media_picture = link_to_photo
        self.follower_name = name
        self.follower_picture = follower_link
    }
    
}
