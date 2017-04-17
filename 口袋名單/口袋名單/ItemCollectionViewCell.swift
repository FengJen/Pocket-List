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
        
        cellTitle.backgroundColor = UIColor.yellow
        cellTitle.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        
        //cellTitle.layer.cornerRadius = 15
    }
    
    
}
