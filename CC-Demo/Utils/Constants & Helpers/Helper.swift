//
//  Helper.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit

class Helper {
    @objc func displayAlert(title: String, message: String, positive: String, negative: String, postiveListener: @escaping() -> Void, negativeListener: @escaping() -> Void, viewController: UIViewController) {
        
        let controller = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction.init(title: positive, style: .default, handler: { (action) in
            postiveListener()
        }))
        controller.addAction(UIAlertAction.init(title: negative, style: .default, handler: { (action) in
            negativeListener()
        }))
        viewController.present(controller, animated: true, completion: nil)
    }
    
    @objc func displayAlert(title: String, message: String, positive: String, postiveListener: @escaping() -> Void, viewController: UIViewController) {
        
        let controller = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction.init(title: positive, style: .default, handler: { (action) in
            postiveListener()
        }))
        viewController.present(controller, animated: true, completion: nil)
    }
    
    @objc func dateFromTimeInterval(interval: Int) -> Date {
        return Date.init(timeIntervalSince1970: TimeInterval(interval))
    }
}


