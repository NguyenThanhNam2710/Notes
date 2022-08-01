//
//  ViewController.swift
//  Notes
//
//  Created by Nam Nguyễn Thành on 31/07/2022.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var isShowLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
        self.bind()
    }
    
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func bind() { }
    
    func showLoading() {
        self.isShowLoading = true
        PopupManager.shared.showLoading()
    }
    
    func hideLoading() {
        self.isShowLoading = false
        PopupManager.shared.hideLoading()
    }
    
}

