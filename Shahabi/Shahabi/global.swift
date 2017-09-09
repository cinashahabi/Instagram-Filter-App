//
//  Global.swift
//  Shahabi
//
//  Created by Casey Takeda on 4/29/17.
//  Copyright © 2017 Casey Takeda. All rights reserved.
//

import Foundation
import UIKit

// Global variable InstagramUser
var instagramUser: InstagramUser!

// Global variable List of Users
var users: [NSDictionary]!

// Global variable List of users you want to follow !
var whitelist = [String : InstagramFollower]()
var whitelist_ids = [String]()

// Global variable for media
var media_array = [String]()
var media_posts = [String : MediaContent]()

// Global Cache
var cachedImages = [String : UIImage]()


