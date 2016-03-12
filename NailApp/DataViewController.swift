//
//  DataViewController.swift
//  pageBasedTest
//
//  Created by DaichiSaito on 2016/02/09.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {
    
    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""
    
    
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
        self.dataLabel!.text = dataObject
    }
    
    
}

