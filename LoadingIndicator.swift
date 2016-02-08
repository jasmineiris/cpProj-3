//
//  LoadingIndicator.swift
//  Yelp
//
//  Created by Jasmine Farrell on 2/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class LoadingIndicator: UIView {

    @IBOutlet weak var logo: UIImageView!

    override func awakeFromNib() {
        self.animate()
    }

    func animate() {
        logo.image = UIImage.animatedImageNamed("AnimatedLogo", duration: 0.80)
    }

    func stopAnimating() {
        logo.image = UIImage(named: "Logo")
    }

}