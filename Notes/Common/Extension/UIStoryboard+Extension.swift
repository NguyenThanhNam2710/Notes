//
//  UIStoryboard+Extension.swift
//  ShowWeb
//
//  Created by Nam Nguyễn Thành on 20/07/2022.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    class func instantiate<T: UIViewController>(name: String, _ type: T.Type) -> T {
        let storyBoard = UIStoryboard(name: name, bundle: nil)
        let instance = storyBoard.instantiateViewController(withIdentifier: String(describing: type)) as! T
        return instance
    }
}
