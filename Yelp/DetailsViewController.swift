//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Jasmine Farrell on 2/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var business: Business!
   
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dealsImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        super.viewDidLoad()
        
        self.navigationItem.title = business.name
        
        if (self.business.imageURL != nil) {
            self.previewImage.setImageWithURL(self.business.imageURL!)
        }
        
        self.previewImage.layer.cornerRadius = 9.0
        self.previewImage.layer.masksToBounds = true
        
        self.ratingImage.setImageWithURL(self.business.ratingImageURL!)
        
        let reviewCount = self.business.reviewCount as! Int
        if (reviewCount == 1) {
            self.reviewLabel.text = "\(reviewCount) review"
        } else {
            self.reviewLabel.text = "\(reviewCount) reviews"
        }
    
        addressLabel.text = business.address
        categoriesLabel.text = business.categories
        distanceLabel.text = business.distance
        
        mapView.addAnnotation(business)
        let bizLoc = CLLocation(latitude: business.coordinate.latitude, longitude: business.coordinate.longitude)
        goToLocation(bizLoc)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        print(location.coordinate)
        mapView.setRegion(region, animated: false)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
