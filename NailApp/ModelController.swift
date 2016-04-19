//
//  ModelController.swift
//  pageBasedTest
//
//  Created by DaichiSaito on 2016/02/09.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//

import UIKit

/*
A controller object that manages a simple model -- a collection of month names.

The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.

There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
*/


class ModelController: NSObject, UIPageViewControllerDataSource {
    
    var pageData: [String] = []
//    var imageData: [UIImage] = []
    var imageArray: NSArray = NSArray()
    var memoArray: NSArray = NSArray()
    var imageInfo = []
    var indexImageInfoArray: Int = 0
    
    // memoArrayとindexPathを引数に持つinit
    init(_imageInfo: NSArray, _indexPath: NSIndexPath) {
        super.init()
        // Create the data model.
        let dateFormatter = NSDateFormatter()
        // 年月。１２月まで。実際不要。
        pageData = dateFormatter.monthSymbols
        // 前画面で選択したcellのindex。
        indexImageInfoArray = _indexPath.row
        // imageInfoの実態。JSON形式。
        imageInfo = _imageInfo
    }
    
    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> DataViewController? {
        // Return the data view controller for the given index.
        // 一番最初、indexには前画面で選択したcellのindexが入る。
        if (index >= self.imageInfo.count) {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewControllerWithIdentifier("DataViewController") as! DataViewController
    
        let targetImageData = self.imageInfo[indexImageInfoArray]
        // dataViewControllerのインスタンス変数に情報を注入
        dataViewController.imageInfo = targetImageData as? NCMBObject
        // ここで二つのVCを返却すればいい感じで次の画像も取得してセットしておくことができるかも。
        return dataViewController
    }
    
    func indexOfViewController(viewController: DataViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        return pageData.indexOf(viewController.dataObject) ?? NSNotFound
//        return imageArray.objectAtIndex(viewController.dataImage) ?? NSNotFound
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
//        self.indexImageInfoArray -= 1
        if (self.indexImageInfoArray == 0) || (self.indexImageInfoArray == NSNotFound) {
            return nil
        }
        self.indexImageInfoArray -= 1
        return self.viewControllerAtIndex(self.indexImageInfoArray, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if self.indexImageInfoArray == NSNotFound {
            return nil
        }
        
        self.indexImageInfoArray += 1
        if self.indexImageInfoArray == self.imageInfo.count {
            return nil
        }
        return self.viewControllerAtIndex(self.indexImageInfoArray, storyboard: viewController.storyboard!)
    }
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        var dvc = pageViewController.viewControllers![0] as! DataViewController
        print(dvc)
        
    }
    
}

