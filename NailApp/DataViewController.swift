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
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var detailImage2: UIImageView!
    var dataObject: String = ""
    var dataImage: UIImage?
//    var imageInfo: NSDictionary = [:]
    var imageInfo: NCMBObject?
//    var url: String = ""
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
//            self.detailImage2.translatesAutoresizingMaskIntoConstraints = true
//            self.contentView.autoresizingMask = autoresizingMask;
            let imageHeight = self.detailImage2.image!.size.height*screenWidth/self.detailImage2.image!.size.width
            self.detailImage2.frame = CGRectMake(0, 0, screenWidth, imageHeight)
        }
//        self.dataLabel!.text = dataObject
//        self.detailImage2.image = dataImage
        
//        //UIImageに画像の名前を指定します
//        let img1 = UIImage(named:"img1.jpg");
//        let img2 = UIImage(named:"img2.jpg");
//        let img3 = UIImage(named:"img3.jpg");
//        //UIImageViewにUIIimageを追加
//        let imageView1 = UIImageView(image:img1)
//        let imageView2 = UIImageView(image:img2)
//        let imageView3 = UIImageView(image:img3)
//        
//        scrollView.frame = CGRectMake(0, 0, 240, 240)
        
        //全体のサイズ
        scrollView.contentSize = CGSizeMake(screenWidth, 1200)  //横幅は画面に合わせ、縦幅は1200とする。
        
        //UIImageViewのサイズと位置を決めます
//        imageView1.frame = CGRectMake(0, 0, 240, 240)
//        imageView2.frame = CGRectMake(240, 0, 240, 240)
//        imageView3.frame = CGRectMake(480, 0, 240, 240)
        //UIImageViewのサイズと位置を決めます
//        imageView1.frame = CGRectMake(0, 0, 240, 240)
//        imageView2.frame = CGRectMake(0, 240, 240, 240)  //変更箇所
//        imageView3.frame = CGRectMake(0, 480, 240, 240)  //変更箇所
//        
//        //UIImageViewをScrollViewに追加します
//        scrollView.addSubview(imageView1)
//        scrollView.addSubview(imageView2)
//        scrollView.addSubview(imageView3)
        
        
    }
    
    
}

