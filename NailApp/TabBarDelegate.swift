//
//  TabBarDelegate.swift
//  NailApp
//
//  Created by DaichiSaito on 2016/04/24.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//

import Foundation
@objc protocol TabBarDelegate {
    
    func didSelectTab(tabBarController: TabBarController)
}