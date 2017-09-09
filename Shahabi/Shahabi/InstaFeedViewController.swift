//
//  InstaFeedViewController.swift
//


import UIKit
import Firebase
import Alamofire

class InstaFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var toProfile: UIButton!
    
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.delegate = self
        feedTableView.dataSource = self
        loadMediaContent()
        self.view.bringSubview(toFront: toProfile)
    }
    
    
    // Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return media_posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedTCell") as! feedTableViewCell
        cell.follower_photo.image = nil
        cell.follower_user_pic.image = nil
        let media_post = media_posts[media_array[indexPath.row]]
        
        let username = media_post?.follower_name
        cell.follower_user_name.text = username
        
        // User Profile
        if let image = cachedImages[username!] {
            cell.follower_user_pic.image = image
        } else {
            let followerURL = URL(string: (media_post?.follower_picture)!)
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: followerURL!) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            cachedImages[username!] = image
                            cell.follower_user_pic.image = image
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code")
                    }
                }
            }
            downloadPicTask.resume()
        }
        
        // User Photo
        let media_id = media_post?.mediaID
        if let image = cachedImages[media_id!] {
            cell.follower_photo.image = image
        } else {
            let followerURL = URL(string: (media_post?.media_picture)!)
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: followerURL!) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            cachedImages[media_id!] = image
                            cell.follower_photo.image = image
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code")
                    }
                }
            }
            downloadPicTask.resume()
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell
    }
    
    
    func loadMediaContent() {
        let myIds = DispatchGroup()
        
        // Reset data
        media_array = [String]()
        media_posts = [String : MediaContent]()
        
        for id in whitelist_ids {
            myIds.enter()
            let link = "https://api.instagram.com/v1/users/\(id)/media/recent/?access_token=" + instagramUser.accessToken
            Alamofire.request(link).responseJSON { response in
                switch(response.result) {
                case .success:
                    let value = response.result.value as! [String: AnyObject]
                    
                    let posts = value["data"] as! [NSDictionary]
                    let posts_length = Int(Double(posts.count) * 0.15)
                    for i in 0 ..< posts_length {
                        let post_media_id = posts[i]["id"]! as! String
                        let post_media_image_dic = posts[i]["images"] as! [String : NSDictionary]
                        let post_media_image_url_dic = post_media_image_dic["standard_resolution"]! as! [String : AnyObject]
                        let post_media_image_link = post_media_image_url_dic["url"]! as!  String
                        let post_user_dic = posts[i]["user"] as! [String : AnyObject]
                        let post_user_name = post_user_dic["username"]! as! String
                        let post_user_link = post_user_dic["profile_picture"] as! String
                        
                        let media = MediaContent(id: post_media_id, link_to_photo: post_media_image_link, name: post_user_name, follower_link: post_user_link)
                        media_array.append(post_media_id)
                        media_posts[post_media_id] = media
                    }
                    
                    break
                // Yeah! Failure!
                case .failure(let error):
                    if let httpStatusCode = response.response?.statusCode {
                        print("statusCode should be 200, but is \(httpStatusCode)")
                        print("response = \(response)")
                    } else {
                        print(error.localizedDescription)
                    }
                    
                }
                
                myIds.leave()
            }
           
        }
        
        myIds.notify(queue: .main) {
            self.feedTableView.reloadData()
        }
        
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
    
    @IBAction func segueToProfile(_ sender: Any) {
        performSegue(withIdentifier: "goToProfile", sender: nil)
    }
    
    
}

