//
//  ViewController.swift
//  Shahabi
//
//  Created by Casey Takeda on 3/28/17.
//  Copyright © 2017 Casey Takeda. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class InstaLogViewController: UIViewController {
    
    @IBAction func connect(_ sender: Any) {
        connectToInstagram()
    }
    
    func connectToInstagram() {
        var request = URLRequest(url: URL(string: IG.INSTAGRAM_AUTHURL)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request) {data, response, err in
            if (err != nil) {
                print("error")
            } else {
                do {
                    // Print out the data (need to grab code)
                    let dataJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
                    let code = dataJson["code"] as! String
                    
                    // Request the access_token
                    self.requestAccessTokenAlamo(code: code)
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
    }
    
    // Post Request via Alamofire!
    func requestAccessTokenAlamo(code: String) {
        let params = ["client_id": IG.INSTAGRAM_CLIENT_ID, "client_secret": IG.INSTAGRAM_CLIENTSERCRET, "grant_type": "authorization_code", "redirect_uri": IG.INSTAGRAM_REDIRECT_URI, "code": code]
        Alamofire.request(IG.INSTAGRAM_ACCESS, method: .post, parameters: params, encoding: URLEncoding.default, headers: [:]).responseJSON(completionHandler: {response in
            switch(response.result) {
                case .success:
                    let value = response.result.value as! [String: AnyObject]
                    self.handleAccessToken(data: value)
                    break
                    // Yeah! Response
                case .failure(let error):
                    if let httpStatusCode = response.response?.statusCode {
                        print("statusCode should be 200, but is \(httpStatusCode)")
                        print("response = \(response)")
                    } else {
                        print(error.localizedDescription)
                    }
                
            }
            
            })
    }
    
    // Handle FireBase Login 
    func handleAccessToken(data: [String: AnyObject]) {
        let access_token = data["access_token"] as! String
        let user_dictionary = data["user"] as! [String : AnyObject]
        let user_name = user_dictionary["username"] as! String
        instagramUser = InstagramUser(username: user_name, accessToken: access_token)
        
        // Sets up the people you follow...
        let get_users_request = IG.INSTAGRAM_GET_USERS + instagramUser!.accessToken
        grabUsers(link: get_users_request)
    }
    
    // Grabbing users :D
    func grabUsers(link: String) {
        var request = URLRequest(url: URL(string: link)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request) {data, response, err in
            if (err != nil) {
                print("error")
            } else {
                do {
                    // Print out the data (need to grab code)
                    let dataJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
                    
                    // Set up users :D
                    users = dataJson["data"] as! [NSDictionary]
                    
                    // Load whitelist
                    self.loadWhiteList()
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            }.resume()
        
    }
    
    func loadWhiteList() {
        // Reset Data
        whitelist = [String : InstagramFollower]()
        whitelist_ids = [String]()
        
        let length_users = users.count
        for i in 0 ..< length_users {
            let a_user_name = users![i]["username"]! as! String
            let a_user_id = users![i]["id"] as! String
            let a_user_pro_pic = users![i]["profile_picture"] as! String
            let a_instagram_follower = InstagramFollower(username: a_user_name, id: a_user_id, link_to_photo: a_user_pro_pic)
            whitelist[a_user_id] = a_instagram_follower
            whitelist_ids.append(a_user_id)
        }
        // After grabbing your users... segue!
        self.performSegue(withIdentifier: "goToFeed", sender: self)
        
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

