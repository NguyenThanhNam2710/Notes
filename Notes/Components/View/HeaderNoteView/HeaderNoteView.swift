//
//  HeaderNoteView.swift
//  Notes
//
//  Created by Nam Nguyễn Thành on 31/07/2022.
//

import UIKit

class HeaderNoteView: BaseCustomView {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    fileprivate func setupView() { }
    
    func setData(date: String) {
        timeLabel.text = date
    }
    
}
