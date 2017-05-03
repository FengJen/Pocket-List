//
//  CellViewCollectionViewCell.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/28.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellTitle: UIButton!

    @IBOutlet weak var myImageView: UIImageView!
    
          // self.window?.rootViewController?.present(vc, animated: true, completion: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //cellTitle.backgroundColor = UIColor.yellow
        cellTitle.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        
        self.layer.cornerRadius = 10
        
        
        
//        let maskPath = UIBezierPath(roundedRect: myImageView.bounds,
//                                    byRoundingCorners: [.allCorners],
//                                    cornerRadii: CGSize(width: 20.0, height: 20.0))
//        
//        let shape = CAShapeLayer()
//        shape.path = maskPath.cgPath
//        myImageView.layer.mask = shape
        
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        // get frame
        // layer != view
        self.cellTitle.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        self.myImageView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
    
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

