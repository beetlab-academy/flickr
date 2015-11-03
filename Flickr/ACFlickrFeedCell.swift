//
//  ACFlickrFeedCell.swift
//  Flickr
//
//  Created by User on 29.09.15.
//  Copyright © 2015 qswitch. All rights reserved.
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

// MARK: процедуры конфигурации клетки

extension ACFlickrFeedCell
{
    func configureSelfWithModel (postModel : ACPost ) -> Void
    {
        
        if ( postModel.mainPhotoURL == nil)
        {
            internetTask = ACPostManager.uploadPhotoURLSofPostWithID(postModel, success: { () -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.flickrPhoto.pin_setImageFromURL(postModel.mainPhotoURL!)
                    
                    })
                
                }) { () -> Void in
                    
            }
        }
        else
        {
            self.flickrPhoto.pin_setImageFromURL(postModel.mainPhotoURL!)
        }

        photoTitle.text = postModel.postTitle
        
    }
}

//MARK: Отмена задачи загрузки ссылок

extension ACFlickrFeedCell
{
    override func prepareForReuse()
    {
        flickrPhoto.image = nil
        internetTask?.cancel()
    }
}
