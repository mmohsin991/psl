//
//  MostRecentViewed.swift
//  psl
//
//  Created by Raza Master on 1/7/15.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit
import CoreData

class MostRecentViewed: UITableViewController {

    var items: [AnyObject]!
    
    var barButtonItemRight : UIBarButtonItem! // add a custom barButtonItem for home image
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        
        // show the navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // make a custom button use in barButtonItem constructor for initilization
        let homeBtn1 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        homeBtn1.setImage(UIImage(named: "home_icon_green"), forState: UIControlState.Normal)
        homeBtn1.adjustsImageWhenHighlighted = false
        
        // add the action with the button
        homeBtn1.addTarget(self, action: "home1", forControlEvents: UIControlEvents.TouchUpInside)
        
        // set a barButtonItemRight with our custom button
        self.barButtonItemRight = UIBarButtonItem(customView: homeBtn1)
        
        // add barButtonItem to navigation bar right button
        self.navigationItem.setRightBarButtonItem(self.barButtonItemRight, animated: true)
        
        // set the custom image title of navigation item
        let titleImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        titleImage.image = UIImage(named: "psl_bar_logo")
        self.navigationItem.titleView = titleImage
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()

        
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fReq = NSFetchRequest(entityName: "MostRecent")
        
        let allItems = context.executeFetchRequest(fReq, error: nil)!
        
        // make it reverse to sort the table in last viewed first order
        self.items = allItems.reverse()
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // make the custom header for section
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIButton(frame: CGRect(x: 0, y: 0, width: 240, height: 50))
        sectionView.setImage(UIImage(named: "recentlyviewed_grn_btn"), forState: UIControlState.Normal)
        sectionView.setTitle("RECENTLY VIEWED", forState: UIControlState.Normal)
        sectionView.setTitleColor(UIColor(red: 0.074509, green: 0.650980, blue: 0.313725, alpha: 1.0), forState: UIControlState.Normal)
        sectionView.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
        sectionView.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        sectionView.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0)
        sectionView.titleEdgeInsets = UIEdgeInsetsMake(0.0, 30.0, 0.0, 0.0)
        
        sectionView.backgroundColor = UIColor.whiteColor()
        sectionView.layer.borderWidth = 1.0
        sectionView.layer.cornerRadius = 0.0
        sectionView.layer.borderColor = UIColor(red: 0.074509, green: 0.650980, blue: 0.313725, alpha: 1.0).CGColor
        
        // when this property is false then the button image will not highlighted when we touch/tap it
        sectionView.adjustsImageWhenHighlighted = false
        
        return sectionView
    }
    
    // set the heigt of the Section
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if items.isEmpty == false {
            return items.count
        }
        else {
            return 0
        }
    }

    // set the heigt of the row
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        

            let item = items[indexPath.row ] as NSManagedObject
            cell.textLabel?.text = item.valueForKey("name") as? String
            cell.backgroundColor = UIColor.whiteColor()
            cell.textLabel?.textColor = UIColor.blackColor()

        
        cell.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 15.0)

        
        return cell
    }

    // change the color of row when we select the row
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.backgroundColor = UIColor(red: 0.074509, green: 0.650980, blue: 0.313725, alpha: 1.0)
            cell?.textLabel?.textColor = UIColor.whiteColor()
            performSegueWithIdentifier("mostRecentVideoPlayback", sender: self)

    }
    // change the color of row when we select an other row
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.backgroundColor = UIColor.whiteColor()
            cell?.textLabel?.textColor = UIColor.blackColor()
        
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.

            return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDel.managedObjectContext as NSManagedObjectContext!
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let tv = tableView {
                context.deleteObject(items[indexPath.row ] as NSManagedObject)
                items.removeAtIndex(indexPath.row )
                tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            var error : NSError?
            if !context.save(&error){
                abort()
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mostRecentVideoPlayback" {
            
            let videoVC = segue.destinationViewController as VideoPlaybackViewController
            
            videoVC.categoryVideos = convertEntitiesToItems(items)
            let index = self.tableView.indexPathForSelectedRow()?.row
            videoVC.index = index!
        }
    }
    
    // helper func that convert coredata Entites to our DataBase swift file Item Class object Array
    func convertEntitiesToItems (entities: [AnyObject]) -> [Item]{
        var tempItems = [Item]()
        
        for entity in entities {
            let manageObjectEntity = entity as NSManagedObject
            let name = manageObjectEntity.valueForKey("name") as String
            let url = manageObjectEntity.valueForKey("url") as String
            let thumbImg = manageObjectEntity.valueForKey("thumbImg") as String
            
            tempItems.append(Item(url: url, thumbImg: thumbImg, name: name))
            
        }
        
        return tempItems
    }
    @IBAction func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func home1() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

}

