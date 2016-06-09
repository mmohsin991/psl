//
//  MainSearchTableVC.swift
//  psl
//
//  Created by Muhammad Mohsin on 1/7/15.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit

class MainSearchTableVC: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate  {
    
    var searchItem = [Item]()
    
    var barButtonItemRight : UIBarButtonItem! // add a custom barButtonItem for home image
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        
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
        
        
        
        // show the navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // set the custom image title of navigation item
        let titleImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        titleImage.image = UIImage(named: "psl_bar_logo")
        self.navigationItem.titleView = titleImage
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.searchItem.count
        }
        else {
            return 1
        }
    }
    
    // set the heigt of the row
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            let item = self.searchItem[indexPath.row]

            cell.textLabel!.text = item.name

            // Configure the cell selection color
            let backgroundColorView = UIView()
            backgroundColorView.backgroundColor = UIColor(red: 0.074509, green: 0.650980, blue: 0.313725, alpha: 1.0)
            cell.selectedBackgroundView = backgroundColorView
        }
        else {
            cell.textLabel!.text = "Kindly search the video"
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.textLabel?.textColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.7)
            cell.textLabel?.font = UIFont.boldSystemFontOfSize(20)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selectionStyle = UITableViewCellSelectionStyle.None

        }
        cell.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 15.0)

        return cell
    }
    
    
    //  These two methods are part of the UISearchDisplayControllerDelegate protocol. They will call the content filtering function when the the user enters a search query. The first method runs the text filtering function whenever the user changes the search string in the search bar. The second method will handle the changes in the Scope Bar input. You haven’t yet added the Scope Bar in this tutorial, but you might as well add this UISearchBarDelegate method now since you’re going to need it later.


    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String?) -> Bool {
        self.filterItemsForName(searchString!)
        return true
    }
    
// there is no need of this b/c we dnt impliment scope bar here
//    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
//        self.filterItemsForName(self.searchDisplayController!.searchBar.text)
//        return true
//    }
    
    
    // helper function which search the videos a/c to given video name in just category
    func filterItemsForName(name: String){
        
        // when ever this fn call first it empty the old array of searchItem and then re-load it with new given sub-string(search string)
        self.searchItem = []
        
        for (category,videos) in globalDB {
            
            videos.filter({( item: Item) -> Bool in
            let stringMatch = item.name.lowercaseString.rangeOfString(name.lowercaseString)
                
                // If it find the substring in the name then it append in searhItem array
                if stringMatch != nil {
                    self.searchItem.append(item)
                }
                
            return (stringMatch != nil)
            })
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // NOTE: use "performSegueWithIdentifier" instead of storyboard segue from table cell to other VC
        if tableView == self.searchDisplayController?.searchResultsTableView {
            performSegueWithIdentifier("searchVideoPlayback", sender: tableView)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "searchVideoPlayback" {
            
            let videoVC = segue.destinationViewController as! VideoPlaybackViewController
            
            if sender as! UITableView == self.searchDisplayController!.searchResultsTableView {
                videoVC.index = self.searchDisplayController?.searchResultsTableView.indexPathForSelectedRow!.row
                videoVC.categoryVideos = self.searchItem
            }
            
//            // it will never use if we dnt populate the table with whole data at view did load
//            else {
//                videoVC.index  = self.tableView.indexPathForSelectedRow()!.row
//                videoVC.categoryVideos = nil
//            }
        }
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func home1(){
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
}
