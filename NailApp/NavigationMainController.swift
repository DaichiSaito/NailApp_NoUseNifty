//
//  TestDaichiViewControllers.swift
//  JisakuTabView
//
//  Created by DaichiSaito on 2016/02/07.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//

import UIKit

class NavigationMainController: UINavigationController,UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate {
    let X_BUFFER:CGFloat = 0  //%%% the number of pixels on either side of the segment
    
    let HEIGHT:CGFloat = 30   //%%% height of the segment
    
    let X_OFFSET:CGFloat = 8 //%%% for some reason there's a little bit of a glitchy offset.  I'm going to look for a better workaround in the future
    let Y_BUFFER:CGFloat = 14 //%%% number of pixels on top of the segment
    let SELECTOR_Y_BUFFER:CGFloat = 40 //%%% the y-value of the bar that shows what page you are on (0 is the top)
    let SELECTOR_HEIGHT:CGFloat = 4 //%%% thickness of the selector bar
    
    var pageScrollView : UIScrollView
    var pageController : UIPageViewController
    var navigationView : UIView
    var selectionBar : UIView
    var currentPageIndex :Int = 0
    
    var viewControllerArray:[UIViewController] = []
    var navDelegate:AnyObject?
    var panGestureRecognizer :UIPanGestureRecognizer?
    var buttonText :[String] = []
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        pageScrollView = UIScrollView()
        pageController = UIPageViewController()
        navigationView = UIView()
        selectionBar = UIView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        pageScrollView = UIScrollView()
        pageController = UIPageViewController()
        navigationView = UIView()
        selectionBar = UIView()
        super.init(coder: aDecoder)
    }
    
    required override init(rootViewController: UIViewController) {
        pageScrollView = UIScrollView()
        pageController = UIPageViewController()
        navigationView = UIView()
        selectionBar = UIView()
        super.init(rootViewController: rootViewController)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor(red:0.01, green:0.05, blue:0.06, alpha:1) //%%% bartint
        self.navigationBar.translucent = false
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //%%% sets up the tabs using a loop.  You can take apart the loop to customize individual buttons, but remember to tag the buttons.  (button.tag=0 and the second button.tag=1, etc)
    func setupSegmentButtons() {
        
        navigationView = UIView(frame: CGRectMake(0,0,self.view.frame.size.width,self.navigationBar.frame.size.height))
        
        let numControllers :Int = viewControllerArray.count
        
        if (buttonText.count == 0) {
            buttonText = ["New","Popular","Favorite"] //%%%buttontitle
        }
        
        for (var i = 0 ; i < numControllers; i++) {
            let frame :CGRect = CGRectMake(X_BUFFER+CGFloat(i)*(self.view.frame.size.width-2*X_BUFFER)/CGFloat(numControllers)-X_OFFSET, Y_BUFFER, (self.view.frame.size.width-2*X_BUFFER)/CGFloat(numControllers), HEIGHT)
            let button :UIButton = UIButton(frame: frame)
            navigationView.addSubview(button)
            
            button.tag = i //%%% IMPORTANT: if you make your own custom buttons, you have to tag them appropriately
            button.backgroundColor = UIColor(red: 0.03, green: 0.07, blue: 0.08, alpha: 1) //%%% buttoncolors
            button.addTarget(self, action: "tapSegmentButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            button.setTitle(buttonText[i], forState:UIControlState.Normal) //%%%buttontitle
        }
        
        pageController.navigationController?.navigationBar.topItem?.titleView = navigationView
        
        self.setupSelector()
    }
    
    //%%% sets up the selection bar under the buttons on the navigation bar
    func setupSelector() {
        selectionBar = UIView(frame: CGRectMake(X_BUFFER-X_OFFSET, SELECTOR_Y_BUFFER,(self.view.frame.size.width-2*X_BUFFER)/CGFloat(viewControllerArray.count), SELECTOR_HEIGHT))
        selectionBar.backgroundColor = UIColor.greenColor() //%%% sbcolor
        selectionBar.alpha = 0.8; //%%% sbalpha
        navigationView.addSubview(selectionBar)
    }
    
    //generally, this shouldn't be changed unless you know what you're changing
    ////////////////////////////////////////////////////////////
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
    //%%%%%%%%%%%%%%%%%%        SETUP       %%%%%%%%%%%%%%%%%%//
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
    //                                                        //
    override func viewWillAppear(animated: Bool) {
        self.setupPageViewController()
        self.setupSegmentButtons()
    }
    
    //%%% generic setup stuff for a pageview controller.  Sets up the scrolling style and delegate for the controller
    func setupPageViewController() {
        pageController = self.topViewController as! UIPageViewController
        pageController.delegate = self
        pageController.dataSource = self
        pageController.setViewControllers([viewControllerArray[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        self.syncScrollView()
    }
    
    //%%% this allows us to get information back from the scrollview, namely the coordinate information that we can link to the selection bar.
    func syncScrollView() {
        for view in pageController.view.subviews {
            if view.isKindOfClass(UIScrollView) {
                pageScrollView = view as! UIScrollView
                pageScrollView.delegate = self
            }
        }
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    //%%% methods called when you tap a button or scroll through the pages
    // generally shouldn't touch this unless you know what you're doing or
    // have a particular performance thing in mind
    //////////////////////////////////////////////////////////
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
    //%%%%%%%%%%%%%%%        MOVEMENT         %%%%%%%%%%%%%%//
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
    //                                                      //
    
    //%%% when you tap one of the buttons, it shows that page,
    //but it also has to animate the other pages to make it feel like you're crossing a 2d expansion,
    //so there's a loop that shows every view controller in the array up to the one you selected
    //eg: if you're on page 1 and you click tab 3, then it shows you page 2 and then page 3
    func tapSegmentButtonAction(button:UIButton) {
        
        let tempIndex:Int = currentPageIndex
        
        weak var weakSelf = self
        
        //%%% check to see if you're going left -> right or right -> left
        if button.tag > tempIndex {
            //%%% scroll through all the objects between the two points
            for var i = tempIndex+1 ; i <= button.tag ; i++ {
                let index = i
                pageController.setViewControllers([viewControllerArray[i]], direction:UIPageViewControllerNavigationDirection.Forward, animated: true, completion: {complete in
                    
                    //%%% if the action finishes scrolling (i.e. the user doesn't stop it in the middle),
                    //then it updates the page that it's currently on
                    if complete {
                        weakSelf?.updateCurrentPageIndex(index)
                    }
                })
            }
        }
            
            //%%% this is the same thing but for going right -> left
        else if button.tag < tempIndex {
            for var i = tempIndex-1 ; i >= button.tag ; i-- {
                let index = i
                pageController.setViewControllers([viewControllerArray[i]], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: {complete in
                    if complete {
                        weakSelf?.updateCurrentPageIndex(index)
                    }
                })
            }
        }
    }
    
    //%%% makes sure the nav bar is always aware of what page you're on
    //in reference to the array of view controllers you gave
    func updateCurrentPageIndex(newIndex:Int) {
        currentPageIndex = newIndex
    }
    
    //%%% method is called when any of the pages moves.
    //It extracts the xcoordinate from the center point and instructs the selection bar to move accordingly
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let xFromCenter:CGFloat = self.view.frame.size.width - pageScrollView.contentOffset.x //%%% positive for right swipe, negative for left
        
        //%%% checks to see what page you are on and adjusts the xCoor accordingly.
        //i.e. if you're on the second page, it makes sure that the bar starts from the frame.origin.x of the
        //second tab instead of the beginning
        let xCoor:CGFloat = X_BUFFER + selectionBar.frame.size.width * CGFloat(currentPageIndex) - X_OFFSET;
        
        selectionBar.frame = CGRectMake(xCoor-xFromCenter/CGFloat(viewControllerArray.count), selectionBar.frame.origin.y, selectionBar.frame.size.width, selectionBar.frame.size.height);
    }
    // MARK: Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index :Int = self.indexOfController(viewController);
        if (index == NSNotFound) {
            return nil
        }
        index--
        if (0 <= index && index < viewControllerArray.count) {
            return viewControllerArray[index]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index :Int = self.indexOfController(viewController)
        if (index == NSNotFound) {
            return nil
        }
        index++
        if (0 <= index && index < viewControllerArray.count) {
            return viewControllerArray[index]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed) {
            currentPageIndex = self.indexOfController(pageViewController.viewControllers!.last!)
        }
    }
    //%%% checks to see which item we are currently looking at from the array of view controllers.
    // not really a delegate method, but is used in all the delegate methods, so might as well include it here
    func indexOfController(viewController :UIViewController) -> Int {
        for (var i = 0 ; i < viewControllerArray.count ; i++) {
            if (viewController == viewControllerArray[i]) {
                return i
            }
        }
        return NSNotFound
    }
    
}
