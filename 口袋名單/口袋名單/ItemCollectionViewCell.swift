//
//  CellViewCollectionViewCell.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/28.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    //let customCell = ItemCollectionViewCell()
    
    @IBOutlet weak var cellTitle: UIButton!

    @IBAction func toContentView(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CellDetailViewController")
        //self.window?.rootViewController?.navigationController?.pushViewController(vc, animated: true)
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setUp() {
        self.cellTitle.setTitle("", for: .normal)
    }
}
