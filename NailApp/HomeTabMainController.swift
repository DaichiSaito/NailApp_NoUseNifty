//
//  RootViewController.swift
//  pageBased2
//
//  Created by DaichiSaito on 2016/02/11.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//

import UIKit
extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}
class HomeTabMainController: UIViewController, UIPageViewControllerDelegate {

    @IBAction func updateView(sender: AnyObject) {
        loadView()
        viewDidLoad()
    }
    // 投稿ボタン押下時処理
    @IBAction func uploadButton(sender: AnyObject) {
        // ユーザー情報取得
        let carrentUser = NCMBUser.currentUser()
        if(carrentUser == nil) {
            // 未ログイン時の処理
            let alertController = UIAlertController(title: "Sorry!", message: "会員専用です。ログインして。", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        } else {
            // ログイン時は後続の処理へ進む。
            let chooseFromCameraInstanse: chooseFromCamera = chooseFromCamera()
            self.addChildViewController(chooseFromCameraInstanse)
            self.view.addSubview(chooseFromCameraInstanse.view)
            chooseFromCameraInstanse.uploadImages()
//            chooseFromCameraInstanse.removeFromParentViewController()
//            chooseFromCameraInstanse.view.removeFromSuperview()
        }
        
    }
    var pageViewController: UIPageViewController?
    
    @IBOutlet weak var navigationSubView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // New,Popularの横スクロール用VC
        let pageController:UIPageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        // なんでnavigationなんだっけ？
        // ここのrootViewControllerにはselfを入れないといけないのかな？
        let navigationController:NavigationMainController = NavigationMainController(rootViewController: pageController)
        // New側のVC本体
        let CollectionViewMainController1 = self.storyboard!.instantiateViewControllerWithIdentifier( "collectionViewMain" ) as! CollectionViewMainController
//        let topView = CollectionViewMainController1.topViewController as CollectionViewMainController
        CollectionViewMainController1.orderByKey = "createDate"
        CollectionViewMainController1.tabKindSign = "1"
        print("frame")
        print(CollectionViewMainController1.view.frame) // 414と736なので画面いっぱい
        print(self.view.frame) // 414と736なので画面いっぱい
//        let rect:CGRect = CGRectMake(0, 0, 300, 300)
//        CollectionViewMainController1.view.frame = rect
        CollectionViewMainController1.view.backgroundColor = UIColor.blueColor()
        // Popular側のVC本体。今はNew側と同じものを一旦設定している。
        let CollectionViewMainController2 = self.storyboard!.instantiateViewControllerWithIdentifier( "collectionViewMain" ) as! CollectionViewMainController
        CollectionViewMainController2.orderByKey = "kawaiine"
        CollectionViewMainController2.tabKindSign = "2"
//        CollectionViewMainController2.view.frame = self.view.frame
        // FavoriteのVC本体。
        let CollectionViewMainController3 = self.storyboard!.instantiateViewControllerWithIdentifier( "collectionViewMain" ) as! CollectionViewMainController
        CollectionViewMainController3.orderByKey = "createDate"
        CollectionViewMainController3.tabKindSign = "3"
        // この配列がNew,Popularのナビゲーションに対応している。そういう仕様。
        navigationController.viewControllerArray = [CollectionViewMainController1,CollectionViewMainController2,CollectionViewMainController3]
        // navigationControllerをHomeTabViewにaddChildViewController
        self.addChildViewController(navigationController)
        // navigationControlleのviewをHomeTabViewが持っているサブビュー部分にaddSubView
        navigationSubView.addSubview(navigationController.view)
        print("navigationSubView.frame")
        print(navigationSubView.frame)
//        navigationSubView.setTranslatesAutoresizingMaskIntoConstraints(true)
//        navigationSubView.translatesAutoresizingMaskIntoConstraints = false
//        navigationSubView.frame = self.view.frame
        print(navigationSubView.frame)
        //        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        // 謎
        var pageViewRect = self.view.bounds
        print("self.view.bounds")
        print(self.view.bounds)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0)
        }
        // 謎
        print("pageController.view.frame")
        print(pageController.view.frame)
        print("navigationController.pageController.view.frame")
        print(navigationController.pageController.view.frame)
        navigationController.pageController.view.frame = pageViewRect
        // 謎
//        navigationController.pageController.didMoveToParentViewController(self)
        
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        //        self.view.gestureRecognizers = navigationController.pageController.gestureRecognizers
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

