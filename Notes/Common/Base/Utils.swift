//
//  Utils.swift
//  SelexMotor
//
//  Created by Tuan IT. Hoang Anh on 09/06/2022.
//

import Foundation
import UIKit

public func runInMain(_ delay: Double = 0, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
}
