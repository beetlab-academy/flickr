//
//  ACFlickrFeedViewController.swift
//  Flickr
//
//  Created by User on 29.09.15.
//  Copyright © 2015 qswitch. All rights reserved.
//

import UIKit

class ACFlickrFeedViewController: UITableViewController
{
    var postsArray = Array<ACPost>()
    var pageOffset : Int = 2

    override func viewDidLoad()
    {
        super.viewDidLoad()
       // let nib = NSBundle.mainBundle().loadNibNamed("ACFlickrFeedCell", owner: self, options: nil) [0] as! UINib
        
        let nib = UINib (nibName: "ACFlickrFeedCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "flickrImageCell")
        
        ACPostManager.uploadPosts(10, offset: 0, success: { ( array ) -> Void in
            
                self.postsArray.appendContentsOf(array)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            
            }) { () -> Void in
                
                
        }
        
//        ACPostManager.uploadPhotoURLSofPostWithID(ACPost(postIDValue: "22312303665", postTitleValue: "", postAuthorIDValue: ""), success: { () -> Void in
//            
//            }) { () -> Void in
//            
//        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return postsArray.count
    }


    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat // CGFloat - число с плавающей точкой формата Color Grafics (задаем высоту клетки)
    {
        return 220.0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("flickrImageCell", forIndexPath: indexPath) as! ACFlickrFeedCell // Передаем в cell адрес нужной клетки формата flickrFeedCell
        
        if ( indexPath.row == (postsArray.count - 1) )
        {
            ACPostManager.uploadPosts(10, offset: self.pageOffset, success: { ( array ) -> Void in
                print("current \(self.pageOffset)")
                self.pageOffset = ++self.pageOffset
                self.postsArray.appendContentsOf(array)
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.tableView.reloadData()
                    
                })
                
                
                }) { () -> Void in
                    
            }
        }
        
        cell.configureSelfWithModel(postsArray[indexPath.row])
        
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.performSegueWithIdentifier("showDetail", sender: tableView)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
