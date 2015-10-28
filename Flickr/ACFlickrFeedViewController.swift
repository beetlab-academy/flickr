//
//  ACFlickrFeedViewController.swift
//  Flickr
//
//  Created by MacAdmin on 29.09.15.
//  Copyright (c) 2015 Beet Lab. All rights reserved.
//

import UIKit

class ACFlickrFeedViewController: UITableViewController
{
    var postsArray = Array<ACPost>()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let nib = UINib ( nibName: "ACFlickrFeedCell", bundle: nil)
        tableView.registerNib(nib , forCellReuseIdentifier: "flickrImageCell" )
        
        ACPostsManager.uploadPosts(10, offset: 0, success: { ( array ) -> Void in
            
                self.postsArray.appendContentsOf(array)
            
            dispatch_async(dispatch_get_main_queue(), {
            
                self.tableView.reloadData()
            
            })
            
            
            }) { () -> Void in
                
        }
        

        ACPostsManager.uploadPhotoURLSOfPostWithID(ACPost(postIDValue: "22105823785", postTitleValue: "", postAuthorIDValue: ""), success: { () -> Void in
            
            }) { () -> Void in
                
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return postsArray.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 320.0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("flickrImageCell", forIndexPath: indexPath) as! ACFlickrFeedCell
        

//        let photoName = postsArray[indexPath.row].postTitle
//        
//        cell.photoTitle.text = photoName
        
        cell.configureSelfWithModel(postsArray[indexPath.row])

        // Configure the cell...

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
