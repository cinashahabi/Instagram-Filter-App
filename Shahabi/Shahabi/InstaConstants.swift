import Foundation

struct IG {
    
    // https://api.instagram.com/oauth/authorize/?client_id=CLIENT-ID&redirect_uri=REDIRECT-URI&response_type=code
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/?client_id=abbec05b8e0547919024649b6f0121a8&scope=likes+follower_list+public_content&redirect_uri=http://localhost:8000/&response_type=code"
    
    // https://api.instagram.com/oauth/authorize/?client_id=CLIENT-ID&redirect_uri=REDIRECT-URI&response_type=token
    static let INSTAGRAM_IMPLICIT_AUTH_URL = "https://api.instagram.com/oauth/authorize/?client_id=abbec05b8e0547919024649b6f0121a8&redirect_uri=http://localhost:8000/&response_type=token"
    
    static let INSTAGRAM_APIURl  = "https://api.instagram.com/v1/users/"
    
    static let INSTAGRAM_CLIENT_ID  = "abbec05b8e0547919024649b6f0121a8"
    
    static let INSTAGRAM_CLIENTSERCRET = "aa6e31b538e44f78bfc0328e98a03bfd"
    
    static let INSTAGRAM_REDIRECT_URI = "http://localhost:8000/"
    
//    curl -F 'client_id=CLIENT_ID' \
//    -F 'client_secret=CLIENT_SECRET' \
//    -F 'grant_type=authorization_code' \
//    -F 'redirect_uri=AUTHORIZATION_REDIRECT_URI' \
//    -F 'code=CODE' \
//    https://api.instagram.com/oauth/access_token
    static let INSTAGRAM_ACCESS = "https://api.instagram.com/oauth/access_token"
    
    // Get the list of users this user follows.
    static let INSTAGRAM_GET_USERS = "https://api.instagram.com/v1/users/self/follows?access_token="
    
}
