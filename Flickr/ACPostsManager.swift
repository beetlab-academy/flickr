//
//  ACPostsManager.swift
//  Flickr
//
//  Created by MacAdmin on 06.10.15.
//  Copyright © 2015 Beet Lab. All rights reserved.
//

import Foundation

class ACPostsManager
{
    
}
//MARK: загрузка постов
extension ACPostsManager
{
    class func uploadPosts ( count : Int , offset : Int , success : ( postsArray : Array<ACPost>) -> Void , failure : () -> Void ) -> Void
    {
        ACAPI_WRAPPER.getAllInterstingPhotos(offset, photosPerPage: count, success:
            { (jsonResponce) -> Void in
                
                print("internet responce : \(jsonResponce)")
                
                let status = jsonResponce["stat"].stringValue
                
                if ( status != "ok" )
                {
                    failure()
                    return
                }
                
                let photosArraywrapper = jsonResponce["photos"]
                let photosArray = photosArraywrapper["photo"].arrayValue
                var postsOutput = Array<ACPost>()
                
                for ( var i = 0 ; i < photosArray.count ; i++ )
                {
                    let postDictionary = photosArray[i]
                    let postID = postDictionary["id"].stringValue
                    let postTitle = postDictionary["title"].stringValue
                    let postAuthorID = postDictionary["owner"].stringValue
                    
                    let post = ACPost (postIDValue: postID, postTitleValue: postTitle, postAuthorIDValue: postAuthorID)
                    postsOutput.append(post)
                }
                
                success(postsArray: postsOutput)
            })
            { () -> Void in
                failure()
        }
    }
}

//MARK: загрузка фото поста
extension ACPostsManager
{
    class func uploadPhotoURLSOfPostWithID ( post : ACPost , success : () -> Void , failure : () -> Void ) -> NSURLSessionDataTask
    {
        let postID = post.postID
        let task = ACAPI_WRAPPER.getAllPhotosOfPostWithID(postID, success: { (jsonResponce) -> Void in
            
            let status = jsonResponce["stat"].stringValue
            
            if ( status != "ok" )
            {
                failure()
                return
            }
            
            let level1 = jsonResponce ["sizes"]
            let photosArray = level1["size"].arrayValue
            
            for ( var i = 0 ; i < photosArray.count ; i++ )
            {
                let photoDict = photosArray[i]
               // print("photo dict : \(photoDict)")
                
                let photoLabel = photoDict["label"].stringValue
                
                if ( photoLabel == "Medium 640")
                {
                    let url = NSURL ( string: photoDict["source"].stringValue )
                    post.mainPhotoURL = url
                    print("medium url : \(url)")
                }
                
                if ( photoLabel == "Large" )
                {
                    let url = NSURL ( string: photoDict["source"].stringValue )
                    post.originalPhotoURL = url
                    print("original url : \(url)")
                }
            }
            
            success()
            
            }) { () -> Void in
                
        }
        
        return task
    }
}
