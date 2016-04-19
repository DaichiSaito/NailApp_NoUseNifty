//
//  DataViewController.swift
//  pageBasedTest
//
//  Created by DaichiSaito on 2016/02/09.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//
import Foundation
import UIKit

class DataViewController: UIViewController {
    
    @IBOutlet weak var countKwaiine: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var detailImage2: UIImageView!
    @IBOutlet weak var nailistBtn: UIButton!
    var dataObject: String = ""
    var dataImage: UIImage?
    var imageInfo: NCMBObject?
    var url: NSURL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let url = NSURL(string: (self.imageInfo!.objectForKey("imagePath") as? String)!)
        let placeholder = UIImage(named: "transparent.png")
        self.detailImage2.setImageWithURL(url, placeholderImage: placeholder)
        self.detailImage2.frame = CGRectZero
        if (self.detailImage2.image != nil) {
            let imageHeight = self.detailImage2.image!.size.height*screenWidth/self.detailImage2.image!.size.width
            self.detailImage2.frame = CGRectMake(0, 0, screenWidth, imageHeight)
        }
        
        //全体のサイズ
        scrollView.contentSize = CGSizeMake(screenWidth, 1200)  //横幅は画面に合わせ、縦幅は1200とする。
        
        self.nailistBtn.setTitle(self.imageInfo!.objectForKey("userName") as? String!, forState: .Normal)
        // コメントの設定
        if (self.imageInfo!.objectForKey("comment") as? String == nil) {
            self.comment.text = "コメントなし"
        } else {
            self.comment.text = self.imageInfo!.objectForKey("comment") as? String    
        }
        // カワイイネの設定
        if (self.imageInfo!.objectForKey("kawaiine") as? Int == nil) {
            self.countKwaiine.text = "0"
        } else {
            self.countKwaiine.text = String(self.imageInfo!.objectForKey("kawaiine") as! Int)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let controller = segue.destinationViewController as! DetailUserController
        controller.tmpUserName = self.imageInfo?.objectForKey("userName") as? String
        
        
    }
    
    
}

