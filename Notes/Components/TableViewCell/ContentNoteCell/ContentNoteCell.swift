//
//  ContentNoteCell.swift
//  Notes
//
//  Created by Nam Nguyễn Thành on 31/07/2022.
//

import UIKit

class ContentNoteCell: UITableViewCell, CellDataProtocol {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet var dotViews: [UIView]!
    
    var note: NoteModel? {
        didSet {
            guard let note = note else {return}
            if let title = note.title, !title.isEmpty {
                self.titleView.isHidden = false
                self.titleLabel.text = title
            } else {
                self.titleView.isHidden = true
            }
            
            if let noteText = note.note, !noteText.isEmpty {
                self.noteView.isHidden = false
                self.noteLabel.text = noteText
            } else {
                self.noteView.isHidden = true
            }
            
            if self.titleView.isHidden && self.noteView.isHidden {
                if Date().string() == note.createDate {
                    self.noteView.isHidden = false
                    self.noteLabel.text = "Thêm cho hôm nay"
                }
                self.bottomStackView.isHidden = true
            } else {
                self.bottomStackView.isHidden = false
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(_ data: Any?) {
        if let data = data as? NoteModel {
            note = data
        }
        
    }
}
