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
        let CollectionViewMainController1 = self.storyboard!.instantiateViewControllerWithIdentifier( "collectionViewMain" )
        print("frame")
        print(CollectionViewMainController1.view.frame)
        print(self.view.frame)
        let rect:CGRect = CGRectMake(0, 0, 300, 300)
        CollectionViewMainController1.view.frame = rect
        // Popular側のVC本体。今はNew側と同じものを一旦設定している。
        let CollectionViewMainController2 = self.storyboard!.instantiateViewControllerWithIdentifier( "collectionViewMain" )
        CollectionViewMainController2.view.frame = self.view.frame
        // この配列がNew,Popularのナビゲーションに対応している。そういう仕様。
        navigationController.viewControllerArray = [CollectionViewMainController1,CollectionViewMainController2]
        // navigationControllerをHomeTabViewにaddChildViewController
        self.addChildViewController(navigationController)
        // navigationControlleのviewをHomeTabViewが持っているサブビュー部分にaddSubView
        navigationSubView.addSubview(navigationController.view)
        //        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        // 謎
        var pageViewRect = self.view.bounds
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0)
        }
        // 謎
        navigationController.pageController.view.frame = pageViewRect
        // 謎
        navigationController.pageController.didMoveToParentViewController(self)
        
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        //        self.view.gestureRecognizers = navigationController.pageController.gestureRecognizers
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

