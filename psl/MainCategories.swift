//
//  MainCategories.swift
//  psl
//
//  Created by Muhammad Mohsin on 1/7/15.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit

class MainCategories: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var categoriesImages = ["Adjectives", "Adverbs", "Airport", "Appliances", "Around the House", "Arts", "Basic Phrases", "Bathroom", "Beach", "Beauty", "Bedroom", "Birds", "Body Anatomy", "Brand Names", "Buildings", "Calendar & Time", "Carpentry","Classroom","Cleaning Products","Clothes & Accessories","Colors","Computer", "Countries & Continents","Death","Drinks","Family & Marriage","Famous People","Farming & Agriculture","Flowers, Plants & Trees","Food Dishes","Food","Fruits","Geography","Government","Grammar","Holidays & Celebrations","Hygiene","Insects, Spiders & Reptiles","Jewellery","Health & Medical Care","Kitchen","Law and Order","Living Room","Sports & Games","Mammals","Marine Life","Mathematics","Media","Military","Music & Dance","Numbers","Office & Business","Places in Pakistan","Prepositions","Professions","Pronouns","Science","Sewing","Space","Spices","Transport","Vegetable","Verbs","Weather"]
    
    var barButtonItemRight : UIBarButtonItem!  // add a custom barButtonItem for home image
    
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    var selectedCategoryName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        categoryCollection.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesImages.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! CollectionViewCell
        let collectionViewWidth = collectionView.bounds.size.width
        cell.categoryImage.image = UIImage(named: categoriesImages[indexPath.row])
        cell.categoryName.text = categoriesImages[indexPath.row]
        cell.categoryName.font = UIFont.systemFontOfSize(collectionViewWidth/24)
        
        cell.backgroundColor = UIColor.grayColor()
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //desImg = categoriesImages[indexPath.row]
        selectedCategoryName = categoriesImages[indexPath.row]
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor(red: 0.074509, green: 0.650980, blue: 0.313725, alpha: 1.0)
        
        performSegueWithIdentifier("subCategoriesVC", sender: self)

    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        // NOTE: here is where we say we want cells to use the width of the collection view
        let collectionViewWidth = collectionView.bounds.size.width
        
        // NOTE: here is where we ask our sizing cell to compute what height it needs
        let targetSize = CGSize(width: collectionViewWidth/3.06, height: collectionViewWidth/2.5 )
        return targetSize
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "subCategoriesVC" {

            let detailView = segue.destinationViewController as! SubCategoryList
            detailView.categoryName = selectedCategoryName
       }
        
    }

    // navigation bar btn items Actions
    @IBAction func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func home1() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
