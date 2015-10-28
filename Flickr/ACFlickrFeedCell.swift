//
//  ACFlickrFeedCell.swift
//  Flickr
//
//  Created by MacAdmin on 29.09.15.
//  Copyright (c) 2015 Beet Lab. All rights reserved.
//

import UIKit

class ACFlickrFeedCell: UITableViewCell
{

    @IBOutlet weak var flickrPhoto: UIImageView!
    @IBOutlet weak var photoTitle: UILabel!
    weak var internetTask : NSURLSessionDataTask?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: процедуры конфигурации клетки
extension ACFlickrFeedCell
{
    func configureSelfWithModel ( postModel : ACPost ) -> Void
    {
        if ( postModel.mainPhotoURL == nil )
        {
            internetTask = ACPostsManager.uploadPhotoURLSOfPostWithID(postModel, success: { () -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let manager:SDWebImageManager = SDWebImageManager.sharedManager()
                    manager.downloadImageWithURL(postModel.mainPhotoURL, options: SDWebImageOptions.RetryFailed, progress: nil, completed:
                        { (image, error, ImageCacheType, succeed, url) -> Void in
                        if (image != nil)
                        {
                        self.flickrPhoto.image = image
                        }
                    })
                    
                })
                
                }) { () -> Void in
                    
            }
        }
        else
        {
            let manager:SDWebImageManager = SDWebImageManager.sharedManager()
            manager.downloadImageWithURL(postModel.mainPhotoURL, options: SDWebImageOptions.RetryFailed, progress: nil, completed:
                { (image, error, ImageCacheType, succeed, url) -> Void in
                if (image != nil)
                {
                self.flickrPhoto.image = image
                }
            })
        }
        photoTitle.text = postModel.postTitle
    }
}

// MARK: отмена задачи загрузки ссылок
extension ACFlickrFeedCell
{
    
    override func prepareForReuse()
    {
        flickrPhoto.image = nil
        internetTask?.cancel()
    }
}