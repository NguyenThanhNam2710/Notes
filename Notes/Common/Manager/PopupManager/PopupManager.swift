//
//  PopupManager.swift
//  Foxpay
//
//  Created by Nguyen Huy Quang on 10/8/20.
//

import Foundation
import UIKit

class PopupManager {
    public static let shared = PopupManager()
    public init() {}
    
    fileprivate weak var loadingView: LoadingView?
    
    func showLoading() {
        self.loadingView?.dismiss()
        let loadingView = LoadingView.instance()
        loadingView.show(in: nil)
        self.loadingView = loadingView
    }
    
    func hideLoading() {
        self.loadingView?.dismiss()
        self.loadingView = nil
    }
}
