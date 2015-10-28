//
//  ACPost.swift
//  Flickr
//
//  Created by MacAdmin on 13.10.15.
//  Copyright © 2015 Beet Lab. All rights reserved.
//

import Foundation


class ACPost
{
    var postID : String
    var postTitle : String
    var postAuthorID : String
    var mainPhotoURL : NSURL?
    var originalPhotoURL : NSURL?
    
    init ( postIDValue : String , postTitleValue : String , postAuthorIDValue : String )
    {
        postID = postIDValue
        postTitle = postTitleValue
        postAuthorID = postAuthorIDValue
    }
    
}
