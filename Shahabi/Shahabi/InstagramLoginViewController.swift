//
//  ViewController.swift
//  Shahabi
//
//  Created by Casey Takeda on 3/28/17.
//  Copyright © 2017 Casey Takeda. All rights reserved.
//

import UIKit
import Firebase

class InstagramLoginViewController: UIViewController {
    
    typealias JSONDictionary = [String:Any]
    var user: InstagramUser?
    
    @IBAction func connect(_ sender: Any) {
        connectInstagram()
    }
    
    func connectInstagram() {
        
        let auth: NSMutableDictionary = ["client_id": IG.INSTAGRAM_CLIENT_ID,
                                         SimpleAuthRedirectURIKey: IG.INSTAGRAM_REDIRECT_URI]
        
        SimpleAuth.configuration()["instagram"] = auth
        SimpleAuth.authorize("instagram", options: [:]) { (result: Any?, error: Error?) -> Void in
            
            if let result = result as? JSONDictionary  {
                
                var token = ""
                var uid = ""
                var bio = ""
                var followed_by = ""
                var follows = ""
                var media = ""
                var username = ""
                var image = ""
                
                token = (result["credentials"] as! JSONDictionary)["token"] as! String
                uid = result["uid"] as! String
                
                if let extra = result["extra"] as? JSONDictionary,
                    let rawInfo = extra ["raw_info"] as? JSONDictionary,
                    let data = rawInfo["data"] as? JSONDictionary {
                    
                    bio = data["bio"] as! String
                    
                    if let counts = data["counts"] as? JSONDictionary {
                        followed_by = String(describing: counts["followed_by"]!)
                        follows = String(describing: counts["follows"]!)
                        media = String(describing: counts["media"]!)
                    }
                }
                
                if let userInfo = result["user_info"] as? JSONDictionary {
                    username = userInfo["username"] as! String
                    image = userInfo["image"] as! String
                }
                
                self.user = InstagramUser(token: token, uid: uid, bio: bio, followed_by: followed_by, follows: follows, media: media, username: username, image: image)
                
                
            } else {
                // this handles if user aborts or the API has a problem like server issue
                let alert = UIAlertController(title: "Error!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            if error != nil {
                print("Error during SimpleAuth.authorize: \(error)")
            }
            
            print("user = \(self.user)")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

