//
//  DetailViewController.swift
//  NailApp
//
//  Created by DaichiSaito on 2016/03/12.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIPageViewControllerDelegate {
    
    
    // prepareForSegueで事前に設定した値がちらほら
    var memoArray: NSArray = NSArray()
    var index: Int = 0
    var indexPath: NSIndexPath = NSIndexPath()
    var imageArray: NSArray = NSArray()
    var pageViewController: UIPageViewController?
    var imageInfo = []
    var _modelController: ModelController? = nil
    
    @IBOutlet weak var detailImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.delegate = self
        // 何番目のVCかをindexPath.rowで指定している。ここで前後のVCも指定してあげるとどうなるんだろ。
        let startingViewController: DataViewController = self.modelController.viewControllerAtIndex(indexPath.row, storyboard: self.storyboard!)!
        // 配列なので複数いける。
        let viewControllers = [startingViewController]
        // 2ページ分のVCを渡すことも可能らしい。
        // http://maplesystems.co.jp/blog/all/programming/20307.html 参照
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
        
        self.pageViewController!.dataSource = self.modelController
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        var pageViewRect = self.view.bounds
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0)
        }
        self.pageViewController!.view.frame = pageViewRect
        
        self.pageViewController!.didMoveToParentViewController(self)
        
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
//        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
        
    
    }
    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            // memoArrayとindexPathを引数にinitを呼ぶ
//            _modelController = ModelController(_imageInfo: imageInfo, _indexPath: indexPath)
            _modelController = ModelController(_imageInfo: imageInfo, _indexPath: indexPath)
        }
        return _modelController!
    }
    
    public func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        print("presentationCount")
        return 1
//        return self.currentPageIndex
    }

}
