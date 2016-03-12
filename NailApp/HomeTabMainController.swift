//
//  RootViewController.swift
//  pageBased2
//
//  Created by DaichiSaito on 2016/02/11.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//

import UIKit

class HomeTabMainController: UIViewController, UIPageViewControllerDelegate {

    @IBAction func updateView(sender: AnyObject) {
        loadView()
        viewDidLoad()
    }
    @IBAction func uploadButton(sender: AnyObject) {
        let chooseFromCameraInstanse: chooseFromCamera = chooseFromCamera()
        self.addChildViewController(chooseFromCameraInstanse)
//        self.view.addSubview(chooseFromCameraInstanse.view)
        chooseFromCameraInstanse.uploadImages()
//        loadView()
//        viewDidLoad()
    }
    var pageViewController: UIPageViewController?
    
    @IBOutlet weak var navigationSubView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pageController:UIPageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        let navigationController:NavigationMainController = NavigationMainController(rootViewController: pageController)
        let CollectionViewMainController1 = self.storyboard!.instantiateViewControllerWithIdentifier( "collectionViewMain" )
        print("frame")
        print(CollectionViewMainController1.view.frame)
        print(self.view.frame)
        let rect:CGRect = CGRectMake(0, 0, 300, 300)
        CollectionViewMainController1.view.frame = rect
        let CollectionViewMainController2 = self.storyboard!.instantiateViewControllerWithIdentifier( "collectionViewMain" )
        CollectionViewMainController2.view.frame = self.view.frame
        navigationController.viewControllerArray = [CollectionViewMainController1,CollectionViewMainController2]
        
        self.addChildViewController(navigationController)
        navigationSubView.addSubview(navigationController.view)
        //        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        var pageViewRect = self.view.bounds
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0)
        }
        navigationController.pageController.view.frame = pageViewRect
        
        navigationController.pageController.didMoveToParentViewController(self)
        
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        //        self.view.gestureRecognizers = navigationController.pageController.gestureRecognizers
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

