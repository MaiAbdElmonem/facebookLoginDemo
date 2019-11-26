//
//  UIView+Extensions.swift
//  FacebookLoginDemo
//
//  Created by Mai Abd Elmonem on 11/25/19.
//  Copyright © 2019 Mai Abd Elmonem. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

//extension UIAlertController {
//
//    func showAlerts() {
//        UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//        self.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
//                      self.openCamera()
//                  }))
//                  alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
//                      self.openGallery()
//                  }))
//                  alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//                  self.present(alert, animated: true, completion: nil)
//}
//}
