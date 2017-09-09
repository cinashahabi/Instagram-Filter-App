import Foundation
import UIKit

class InstagramUser {
    
    // Username
    let username: String
    
    // AccessToken
    let accessToken: String
    
    init(username: String, accessToken: String) {
        self.username = username
        self.accessToken = accessToken
    }
    
}
