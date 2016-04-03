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
    var indexMemoArray: Int = 0
    var memoArray: NSArray = NSArray()
    var imageInfo = []
    var indexImageInfoArray: Int = 0
    
    // memoArrayとindexPathを引数に持つinit
    init(_memoArray: NSArray, _indexPath: NSIndexPath) {
        super.init()
        // Create the data model.
        let dateFormatter = NSDateFormatter()
        // 年月。１２月まで。実際不要。
        pageData = dateFormatter.monthSymbols
        // memoArrayのindex。前画面で選択したcellのindex。
        indexMemoArray = _indexPath.row
        indexImageInfoArray = _indexPath.row
        // memoArrayの実態。JSON形式。
        memoArray = _memoArray
        imageInfo = _memoArray
    }
    
    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> DataViewController? {
        // Return the data view controller for the given index.
        // self.pageData.countは常に12。一番最初、indexには前画面で選択したcellのindexが入る。
        if (self.pageData.count == 0) || (index >= self.imageInfo.count) {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewControllerWithIdentifier("DataViewController") as! DataViewController
        
        // ここに通信処理
//        let targetImageData: NSDictionary = self.imageInfo[indexIgvv mageInfoArray] as! NSDictionary
        let targetImageData = self.imageInfo[indexImageInfoArray]
//        let url = NSURL(string: targetImageData["imagePath"] as! String)
//        let url = NSURL(string: (targetImageData.objectForKey("imagePath") as? String)!)
        
        //        let url = NSURL(targetImageData
        let placeholder = UIImage(named: "transparent.png")
        // dataViewControllerのインスタンス変数に情報を注入
        dataViewController.imageInfo = targetImageData as? NCMBObject
//        dataViewController.url = url
//        dataViewController.detailImage2.setImageWithURL(url, placeholderImage: placeholder)
        //画像データの取得
//        let filename: String = (targetMemoData.objectForKey("filename") as? String)!
//        let fileData = NCMBFile.fileWithName(filename, data: nil) as! NCMBFile
//        
//        fileData.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError!) -> Void in
//            
//            if error != nil {
//                print("写真の取得失敗: \(error)")
//            } else {
//                dataViewController.detailImage2.image = UIImage(data: imageData!)
//            }
//        }

        
//        dataViewController.dataImage = self.imageArray[index] as! UIImage
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
//        var index = self.indexOfViewController(viewController as! DataViewController)
//        var index = self.indexMemoArray
        self.indexImageInfoArray--
        if (self.indexImageInfoArray == 0) || (self.indexImageInfoArray == NSNotFound) {
            return nil
        }
        
//        index--
//        self.indexMemoArray--
        return self.viewControllerAtIndex(self.indexImageInfoArray, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
//        var index = self.indexOfViewController(viewController as! DataViewController)
//        var index = self.indexMemoArray
        if self.indexImageInfoArray == NSNotFound {
            return nil
        }
        
//        index++
        self.indexImageInfoArray++
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

