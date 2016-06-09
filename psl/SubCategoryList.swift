//
//  SubCategoryList.swift
//  psl
//
//  Created by Muhammad Mohsin on 1/7/15.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit
import CoreData

class SubCategoryList: UITableViewController {
    
    var categoryName : String!
    
    var barButtonItemRight : UIBarButtonItem!  // add a custom barButtonItem for home image
    
    
   // var database : [Item] = populateDic()
    var filterdData : [Item]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        
        // show the navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    //    self.tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 50.0, bottom: 0.0, right: 15.0)
    
        
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
        
        
        if categoryName != nil {
            filterdData = globalDB[self.categoryName]
            tableView.reloadData()
            
            // set the custom image title of navigation item
            
            let titleImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
            titleImage.image = UIImage(named: "psl_bar_logo")
            self.navigationItem.titleView = titleImage

        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        

    }

    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        //return segment.titleForSegmentAtIndex(section)
//        return self.categoryName!
//    }
    
    // make the custom header for section
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIButton(frame: CGRect(x: 0, y: 0, width: 240, height: 50))
        sectionView.setImage(UIImage(named: "category_icon_green"), forState: UIControlState.Normal)
        sectionView.setTitle(self.categoryName!.uppercaseString, forState: UIControlState.Normal)
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

    // set the heigt of the row
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }

    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        
        // Return the number of rows in the section.
        if filterdData != nil {
           return filterdData.count
        }
        else {
            return 0
        }
    }
    
    // change the color of row when we select the row
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.backgroundColor = UIColor(red: 0.074509, green: 0.650980, blue: 0.313725, alpha: 1.0)
            cell?.textLabel?.textColor = UIColor.whiteColor()

            // if the row is not the first row of table view b/c its a name of the category dnt perform segue on it

            performSegueWithIdentifier("videoPlayback", sender: self)
    }
    
    // change the color of row when we select an other row
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.whiteColor()
        cell?.textLabel?.textColor = UIColor.blackColor()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell
        // Configure the cell...

            cell.textLabel?.text = filterdData[indexPath.row ].name
            cell.backgroundColor = UIColor.whiteColor()
            cell.textLabel?.textColor = UIColor.blackColor()
        
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 15.0)
        
        
        return cell

    }
    
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "videoPlayback" {
            
            let videoVC = segue.destinationViewController as! VideoPlaybackViewController
            
            videoVC.categoryVideos = filterdData
            let indexOfSelected = self.tableView.indexPathForSelectedRow?.row
            videoVC.index = indexOfSelected!
        }
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func home1() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

}
