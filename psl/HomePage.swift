//
//  HomePage.swift
//  psl
//
//  Created by Raza Master on 1/7/15.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit

class HomePage: UIViewController {

    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnRecentlyViewed: UIButton!
    @IBOutlet weak var btnFavorites: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftInset = CGFloat(self.view.frame.width - 80)
        
        btnSearch.layer.borderWidth = 1.0
        btnSearch.layer.cornerRadius = 4.0
        btnSearch.layer.borderColor = UIColor.grayColor().CGColor
        btnSearch.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnSearch.imageEdgeInsets = UIEdgeInsetsMake(0.0, leftInset, 0.0, 0.0)

        
        btnCategory.layer.borderWidth = 1.0
        btnCategory.layer.cornerRadius = 4.0
        btnCategory.layer.borderColor = UIColor.grayColor().CGColor
        btnCategory.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnCategory.imageEdgeInsets = UIEdgeInsetsMake(0.0, leftInset, 0.0, 0.0)
        
        btnRecentlyViewed.layer.borderWidth = 1.0
        btnRecentlyViewed.layer.cornerRadius = 4.0
        btnRecentlyViewed.layer.borderColor = UIColor.grayColor().CGColor
        btnRecentlyViewed.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnRecentlyViewed.imageEdgeInsets = UIEdgeInsetsMake(0.0, leftInset, 0.0, 0.0)
        
        btnFavorites.layer.borderWidth = 1.0
        btnFavorites.layer.cornerRadius = 4.0
        btnFavorites.layer.borderColor = UIColor.grayColor().CGColor
        btnFavorites.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnFavorites.imageEdgeInsets = UIEdgeInsetsMake(0.0, leftInset, 0.0, 0.0)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        // hide the navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // reset the color of button to gray
        btnSearch.layer.borderColor = UIColor.grayColor().CGColor
        btnSearch.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnSearch.setImage(UIImage(named: "search_btn_gry"), forState: UIControlState.Normal)
        
        // reset the color of button to gray
        btnCategory.layer.borderColor = UIColor.grayColor().CGColor
        btnCategory.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnCategory.setImage(UIImage(named: "category_icon"), forState: UIControlState.Normal)

        // reset the color of button to gray
        btnRecentlyViewed.layer.borderColor = UIColor.grayColor().CGColor
        btnRecentlyViewed.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnRecentlyViewed.setImage(UIImage(named: "recentlyviewed_btn"), forState: UIControlState.Normal)

        // reset the color of button to gray
        btnFavorites.layer.borderColor = UIColor.grayColor().CGColor
        btnFavorites.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnFavorites.setImage(UIImage(named: "favorite_icon_gray"), forState: UIControlState.Normal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func search(sender: UIButton) {
        sender.setImage(UIImage(named: "search_btn_grn"), forState: UIControlState.Normal)
        btnSearch.layer.borderColor = UIColor(red: 0.074509, green: 0.650980, blue: 0.313725, alpha: 1.0).CGColor
        btnSearch.setTitleColor(UIColor(red: 0.074509, green: 0.650980, blue: 0.313725, alpha: 1.0), forState: UIControlState.Normal)
    }
    
    
    @IBAction func categoryClicked(sender: UIButton) {
        sender.setImage(UIImage(named: "category_icon_green"), forState: UIControlState.Normal)
        btnCategory.layer.borderColor = UIColor(red: 0.074509, green: 0.650980, blue: 0.313725, alpha: 1.0).CGColor
        btnCategory.setTitleColor(UIColor(red: 0.074509, green: 0.650980, blue: 0.313725, alpha: 1.0), forState: UIControlState.Normal)
    }

    @IBAction func recentlyViewed(sender: AnyObject) {
        sender.setImage(UIImage(named: "recentlyviewed_grn_btn"), forState: UIControlState.Normal)
        btnRecentlyViewed.layer.borderColor = UIColor(red: 0.074509, green: 0.650980, blue: 0.313725, alpha: 1.0).CGColor
        btnRecentlyViewed.setTitleColor(UIColor(red: 0.074509, green: 0.650980, blue: 0.313725, alpha: 1.0), forState: UIControlState.Normal)
    }
    
    @IBAction func favorite(sender: UIButton) {
        sender.setImage(UIImage(named: "favorite_icon_grn"), forState: UIControlState.Normal)
        btnFavorites.layer.borderColor = UIColor(red: 0.074509, green: 0.650980, blue: 0.313725, alpha: 1.0).CGColor
        btnFavorites.setTitleColor(UIColor(red: 0.074509, green: 0.650980, blue: 0.313725, alpha: 1.0), forState: UIControlState.Normal)
    }


}
