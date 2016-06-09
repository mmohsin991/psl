//
//  VideoPlaybackViewController.swift
//  psl
//
//  Created by Muhammad Mohsin on 1/7/15.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit
import MediaPlayer
import CoreData


class VideoPlaybackViewController: UIViewController {
    
    var barButtonItemRight : UIBarButtonItem! // add a custom barButtonItem for home image
    
    var player:MPMoviePlayerViewController!
    var favorites: [AnyObject]!     // it store the ref. of favorate item in core data
    
    var index: Int!     // pointer to the current video in 
    var categoryVideos: [Item]! // all videos of previous view
    var selectedItem: Item! // only filtered videos a/c to category or favorites or most recent
    
    var appDel: AppDelegate!
    var context: NSManagedObjectContext!

    var isFavorite: Bool = false    // store the current videos's favorite status

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var lblVideoName: UILabel!
    @IBOutlet weak var btnPlayVideo: UIButton!
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var btnPreviousVideo: UIButton!
    @IBOutlet weak var btnNextVideo: UIButton!
    @IBOutlet weak var imgNext: UIImageView!
    @IBOutlet weak var imgPrevious: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.lblVideoName.numberOfLines = 2
        
        self.btnNextVideo.titleLabel?.lineBreakMode = NSLineBreakMode.ByClipping
        self.btnNextVideo.titleLabel?.numberOfLines = 3
        
        self.btnPreviousVideo.titleLabel?.lineBreakMode = NSLineBreakMode.ByClipping
        self.btnPreviousVideo.titleLabel?.numberOfLines = 3
        
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
        
        // set the seleceted item form items lists
        selectedItem = self.categoryVideos[self.index!]
        lblVideoName.text = selectedItem.name
        
        // update the thumb Image of the video
        setThumbImgInBackground()

        
        // Ref to our  app delegate
        self.appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        // ref to moc
        self.context = appDel.managedObjectContext!
        
        // update the favorites item array
        let fReq = NSFetchRequest(entityName: "Favorites")
        
        self.favorites = try! self.context.executeFetchRequest(fReq)
        
        // set or unset the favourate Icon(green or gray)
        setOrUnsetFavourateIcon(self.selectedItem.name)
        
        // set the previous buton name
        if self.index > 0 {
            btnPreviousVideo.setTitle(categoryVideos[self.index - 1].name, forState: UIControlState.Normal)
        }
        else {
            btnPreviousVideo.setTitle("", forState: UIControlState.Normal)
            imgPrevious.hidden = true
        }
        
        // set the next btn name
        if self.index < categoryVideos.count - 1 {
            btnNextVideo.setTitle(categoryVideos[self.index + 1].name, forState: UIControlState.Normal)
        }
        else {
            btnNextVideo.setTitle("", forState: UIControlState.Normal)
            imgNext.hidden = true
        }

    }

    
    override func viewDidAppear(animated: Bool) {
        // if the image didn,t load from web then change the color of button of play video
        btnPlayVideo.setTitle("Play Video", forState: UIControlState.Normal)
        btnPlayVideo.hidden = false
        activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playVideo(sender: AnyObject) {
       // Use YTVimewExtractor to extract embeded video url from vimeo web page
     
        activityIndicator.startAnimating()
        btnPlayVideo.hidden = true

        YTVimeoExtractor.sharedExtractor().fetchVideoWithVimeoURL(selectedItem.url, withReferer: nil) { (video, error) in
            
            if (video != nil) {
                
                var highQualityURL = video!.streamURLs
                if let url = highQualityURL![360]{
                    
                    let urlStr : NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                    let searchURL : NSURL = NSURL(string: urlStr as String)!
                    
                    self.addVideoToMostRecent()
                    
                    self.player = MPMoviePlayerViewController(contentURL: searchURL)
                    
                    self.presentMoviePlayerViewControllerAnimated(self.player)
                
                }else{
                  
                    self.btnPlayVideo.setTitle("Video not available", forState: UIControlState.Normal)
 
                }
            

            }else{
                
                self.btnPlayVideo.setTitle("Video not available", forState: UIControlState.Normal)
            }
            
        }

    }


    @IBAction func AddAndRemoveFavorite(sender: UIButton) {

        
        // remove item from the core data
        if self.isFavorite ==  true {
                        
            // retrive the favorite item from favorite's array
            let favorate : [AnyObject]! = filterItemsForNames(self.favorites, name: self.selectedItem.name)
            let item = favorate[0] as! NSManagedObject
            self.context.deleteObject(item)
            
           // favorite.setTitle("Add to Favorite", forState: UIControlState.Normal)
            favorite.setImage(UIImage(named: "heart_gray"), forState: UIControlState.Normal)

           do {
               try self.context.save()
           } catch _ {
           }
            self.isFavorite = false
            
            // update the favorites item array
            let fReq = NSFetchRequest(entityName: "Favorites")
            self.favorites = try! self.context.executeFetchRequest(fReq)
        }
        
        else if self.isFavorite ==  false {
            let en : NSEntityDescription = NSEntityDescription.entityForName("Favorites", inManagedObjectContext: self.context)!

            // create instance of our data model and initilize
            var newItem = Model(entity: en, insertIntoManagedObjectContext: self.context)
            
            // map our properties
            newItem.name = self.selectedItem.name
            newItem.url = self.selectedItem.url
            newItem.thumbImg = self.selectedItem.thumbImg
            
            do {
                try self.context.save()
            } catch _ {
            }
            self.isFavorite = true
            
            // update the favorites item array
            let fReq = NSFetchRequest(entityName: "Favorites")
            self.favorites = try! self.context.executeFetchRequest(fReq)

            //favorite.setTitle("Remove from Favorite", forState: UIControlState.Normal)
            favorite.setImage(UIImage(named: "heart_green"), forState: UIControlState.Normal)
        }
    }

    func filterItemsForNames(list: [AnyObject], name: String) -> [AnyObject]{
        //  Filter the array using the filter method
        var filterdItem: [AnyObject]!
        filterdItem = list.filter({( item: AnyObject) -> Bool in
            let nsObject = item as! NSManagedObject
            let stringMatch = (nsObject.valueForKey("name") as! String).rangeOfString(name)
            return (stringMatch != nil)
        })
        return filterdItem
    }
    
    // check the video (item) in favorate list
    func checkNameInList(list: [AnyObject]! , name: String) -> Bool {
        let items : [AnyObject]! = filterItemsForNames(list, name: name)
        
        if list.isEmpty || items.isEmpty {
            return false
        }
        else {
            return true
        }
    }
    
    // add the video into most recent list
    func addVideoToMostRecent() {
        
        // update the MostRecent item array
        let fReq = NSFetchRequest(entityName: "MostRecent")
        
        let mostRecentVideos = try! self.context.executeFetchRequest(fReq)
        
        // check the video is already in most recent list
        let isInMostrecent = checkNameInList(mostRecentVideos, name: self.selectedItem.name)
        
        // if the video is alredy in most recent list then first delete the older item from most recet list ans add new exsitance in it because it make this item top of the most recent list
        if isInMostrecent == true {
            
            // retrive the current video item from most recent coredata
            let mostRecent: [AnyObject]! = filterItemsForNames(mostRecentVideos, name: self.selectedItem.name)
            let item = mostRecent[0] as! NSManagedObject
            self.context.deleteObject(item)
            
            
            //self.context.save(nil)
        }
        // if the video is not already in most recent then delete the last video from the list if the most recent's videos count is greater than 15
        else if mostRecentVideos.count >= 15 {
            let item = mostRecentVideos[0] as! NSManagedObject
            self.context.deleteObject(item)
        }
        
        let en : NSEntityDescription = NSEntityDescription.entityForName("MostRecent", inManagedObjectContext: self.context)!
        
        // create instance of our data model and initilize
        let newItem = Model(entity: en, insertIntoManagedObjectContext: self.context)
        
        // map our properties
        newItem.name = self.selectedItem.name
        newItem.url = self.selectedItem.url
        newItem.thumbImg = self.selectedItem.thumbImg
        
        do {
            try self.context.save()
        } catch _ {
        }
        
    }
    
    @IBAction func previousVideo(sender: UIButton) {
        
        // set the previous buton name if next and previous video exist
        if self.index > 1 {
            self.index = self.index - 1
            self.selectedItem = categoryVideos[index]
            lblVideoName.text = selectedItem.name
            
            // update the =thumb Image of the video
            setThumbImgInBackground()
            
            // set or unset the favourate Icon(green or gray)
            setOrUnsetFavourateIcon(self.selectedItem.name)
            
            btnPreviousVideo.setTitle(categoryVideos[self.index - 1].name, forState: UIControlState.Normal)
            imgPrevious.hidden = false
            
            // update the next btn name
            if self.index < categoryVideos.count - 1 {
                btnNextVideo.setTitle(categoryVideos[self.index + 1].name, forState: UIControlState.Normal)
                imgNext.hidden = false
            }
        }
        
        // set the previous buton name if no previous video exist
        else if self.index > 0 {
            self.index = self.index - 1
            self.selectedItem = categoryVideos[index]
            lblVideoName.text = selectedItem.name
            
            // update the =thumb Image of the video
            setThumbImgInBackground()
            
            // set or unset the favourate Icon(green or gray)
            setOrUnsetFavourateIcon(self.selectedItem.name)
            
            btnPreviousVideo.setTitle("", forState: UIControlState.Normal)
            imgPrevious.hidden = true
            
            // update the next btn name
            if self.index < categoryVideos.count - 1 {
                btnNextVideo.setTitle(categoryVideos[self.index + 1].name, forState: UIControlState.Normal)
                imgNext.hidden = false

            }
        }

    }
    
    @IBAction func nextVideo(sender: UIButton) {
        
        // set the next buton name if next and previous video exist
        if self.index < categoryVideos.count - 2 {
            self.index = self.index + 1
            self.selectedItem = categoryVideos[index]
            lblVideoName.text = selectedItem.name
            
            // update the thumb Image of the video
            setThumbImgInBackground()
            
            // set or unset the favourate Icon(green or gray)
            setOrUnsetFavourateIcon(self.selectedItem.name)
            
            btnNextVideo.setTitle(categoryVideos[self.index + 1].name, forState: UIControlState.Normal)
            
            // update the previous buton name
            if self.index > 0 {
                btnPreviousVideo.setTitle(categoryVideos[self.index - 1].name, forState: UIControlState.Normal)
                imgPrevious.hidden = false
            }
        }
            
        // set the next buton name if no next video exist
        else if self.index < categoryVideos.count - 1  {
            self.index = self.index + 1
            self.selectedItem = categoryVideos[index]
            lblVideoName.text = selectedItem.name
            
            // update the thumb Image of the video
            setThumbImgInBackground()
            
            // set or unset the favourate Icon(green or gray)
            setOrUnsetFavourateIcon(self.selectedItem.name)
            
            btnNextVideo.setTitle("", forState: UIControlState.Normal)
            imgNext.hidden = true
            
            // update the previous btn name
            if self.index > 0 {
            btnPreviousVideo.setTitle(categoryVideos[self.index - 1].name, forState: UIControlState.Normal)
            imgPrevious.hidden = false
            }
        }

    }
    
    
    func setThumbImgInBackground() {
        
        var thumbImgData: NSData?
        
        // make a another thread for update the thumb image
        let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
        dispatch_async(dispatch_get_global_queue(priority, 0)){
            // background thread
            thumbImgData =  NSData(contentsOfURL: NSURL(string: self.selectedItem.thumbImg)!)
            
            dispatch_sync(dispatch_get_main_queue()) {
                // main thread
                if thumbImgData != nil {
                    
                    self.thumbImg.image = UIImage(data: thumbImgData!)
                    self.btnPlayVideo.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                }
            }
        }
    }
    
    // helper func to set or unset the favourate Icon(green or gray)
    func setOrUnsetFavourateIcon(name: String){
        if checkNameInList(self.favorites, name: name) == true {
            //favorite.setTitle("Remove from Favorite", forState: UIControlState.Normal)
            favorite.setImage(UIImage(named: "heart_green"), forState: UIControlState.Normal)
            isFavorite = true
        }
            
        else {
            // favorite.setTitle("Add to Favorite", forState: UIControlState.Normal)
            favorite.setImage(UIImage(named: "heart_gray"), forState: UIControlState.Normal)
            
            isFavorite = false
        }
    }
    
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func home1() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
}
