//
//  ACPostManager.swift
//  Flickr
//
//  Created by User on 06.10.15.
//  Copyright © 2015 qswitch. All rights reserved.
//

import Foundation

class ACPostManager
{

    
}

extension ACPostManager
{
    
    class func uploadPosts ( count : Int , offset : Int , success : ( postsArray : Array<ACPost>) -> Void , failure : () -> Void ) -> Void
    {
        ACAPI_WRAPPER.getAllInterestingPhotos(offset, photosPerPage: count, success: { (jsonResponse) -> Void in
            
//            print("internet response : \(jsonResponse)")
            
            let status = jsonResponse["stat"].stringValue
            
            if ( status != "ok")
            {
                failure()
                return
            }
            
            let photosArrayWrapper = jsonResponse["photos"]
            let photosArray = photosArrayWrapper["photo"].arrayValue
            var postsOutput = Array<ACPost>()
            
            for ( var i = 0 ; i < photosArray.count ; i++)
            {
                
                let postDictionary = photosArray[i]
                let postID = postDictionary["id"].stringValue
                let postTitleValue = postDictionary["title"].stringValue
                let postAuthorIDValue = postDictionary["owner"].stringValue
                let post = ACPost(postIDValue: postID, postTitleValue: postTitleValue, postAuthorIDValue: postAuthorIDValue)
                
                
                
                postsOutput.append(post)
                
                
                //                print("post no \(i) is \(postDictionary) and id : \(postID)")
                
            }
            
            success(postsArray: postsOutput)
            
            }) { () -> Void in
                failure()
        }
    }
}

// mark загрузка фото поста

extension ACPostManager
{
    class func uploadPhotoURLSofPostWithID ( post : ACPost , success : () -> Void , failure : () -> Void ) -> NSURLSessionDataTask
    {
        let postID = post.postID
        let task = ACAPI_WRAPPER.getAllPhototsPostWithID(postID, success: { (jsonResponse) -> Void in
            
            let status = jsonResponse["stat"].stringValue
            if ( status != "ok" )
            {
                failure()
                return
            }
            let photosSizeArrayWrapper = jsonResponse["sizes"]
            let photosSizeArray = photosSizeArrayWrapper["size"].arrayValue
            for (var i = 0 ; i < photosSizeArray.count ; i++)
            {
                let photoDictionary = photosSizeArray[i]
                let photoSource = photoDictionary["source"].stringValue
                switch photoDictionary["label"].stringValue
                {
                    case "Medium 640" : post.mainPhotoURL = NSURL ( string: photoSource )
                    case "Large" : post.originalPhotoURL = NSURL ( string : photoSource )
                    default : break
                }
            }
            
            
            print ("Medium url : \(post.mainPhotoURL)")
            print ("Original url : \(post.originalPhotoURL)")
            
            success ()
            
            }) { () -> Void in }
     
        return task
        
    }
}