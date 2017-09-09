//
// ProfileViewController.swift
//

import UIKit
import Firebase
import Alamofire

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var userCollectionView: UICollectionView!
    
    @IBOutlet weak var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCollectionView.delegate = self
        userCollectionView.dataSource = self
        userTableView.delegate = self
        userTableView.dataSource = self
    }
    
    // Collection View Cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return whitelist_ids.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "followerCell", for: indexPath) as! followerCollectionViewCell
        cell.followerImageView.image = nil
        let insta_follower = whitelist[whitelist_ids[indexPath.row]]
        let username = insta_follower?.username
        cell.followerCellName.text = username
        if let image = cachedImages[username!] {
            cell.followerImageView.image = image
        } else {
            let followerURL = URL(string: (insta_follower?.profile_picture)!)
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: followerURL!) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            cachedImages[username!] = image
                            cell.followerImageView.image = image
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
    
    // Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "followerTCell") as! followerTableViewCell
        cell.followerImage.image = nil
        let insta_follower = whitelist[(users![indexPath.row]["id"]! as? String)!]
        let username = insta_follower?.username
        cell.followerName.text = username
        if let image = cachedImages[username!] {
            cell.followerImage.image = image
        } else {
            let followerURL = URL(string: (insta_follower?.profile_picture)!)
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: followerURL!) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            cachedImages[username!] = image
                            cell.followerImage.image = image
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
        
        if (insta_follower?.canView)! {
            cell.followerView.backgroundColor = .blue
        } else {
            cell.followerView.backgroundColor = .red
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    @IBAction func segueToFeed(_ sender: Any) {
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    @IBAction func segueToLogin(_ sender: Any) {
        performSegue(withIdentifier: "toLogInScene", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let insta_follower = whitelist[(users![indexPath.row]["id"]! as? String)!]
        if (insta_follower?.canView)! {
            insta_follower?.canView = false
            whitelist_ids = whitelist_ids.filter{$0 != insta_follower?.instagramID}
        } else {
            insta_follower?.canView = true
            whitelist_ids.append((insta_follower?.instagramID)!)
        }
        userCollectionView.reloadData()
        userTableView.reloadData()
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

