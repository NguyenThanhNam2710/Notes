//
//  EntryViewController.swift
//  Notes
//
//  Created by Nam Nguyễn Thành on 31/07/2022.
//

import UIKit

class EntryViewController: ViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var noteField: UITextView!
    
    public var noteModel: NoteModel?
    
    public var completion: ((NoteModel?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        if let noteModel = noteModel {
            self.dateLabel.text = noteModel.createDate
            self.titleField.text = noteModel.title
            self.noteField.text = noteModel.note
        } else {
            dateLabel.text = Date().string()
            titleField.becomeFirstResponder()
        }
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        if let text = titleField.text, !text.isEmpty, !noteField.text.isEmpty {
            let note: NoteModel = NoteModel(title: titleField.text, note: noteField.text, createDate: dateLabel.text ?? Date().string())
            completion?(note)
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        completion?(nil)
    }
    
}
