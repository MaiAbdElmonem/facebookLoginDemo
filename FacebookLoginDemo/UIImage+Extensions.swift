//
//  UIImage+Extensions.swift
//  FacebookLoginDemo
//
//  Created by Mai Abd Elmonem on 11/26/19.
//  Copyright © 2019 Mai Abd Elmonem. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func makeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
