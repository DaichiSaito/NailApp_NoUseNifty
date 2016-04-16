//
//  MyCollectionViewCell.swift
//  swifttest
//
//  Created by 乾 夏衣 on 2014/06/04.
//  Copyright (c) 2014年 K All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet var image : UIImageView?
    
    @IBOutlet weak var FavImage: UIImageView!
    @IBOutlet weak var labelSample: UILabel!
    var favFlg: Bool!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
//        image!.frame = self.contentView.frame
    }
}
