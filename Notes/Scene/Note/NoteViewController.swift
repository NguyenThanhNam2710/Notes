//
//  NoteViewController.swift
//  Notes
//
//  Created by Nam Nguyễn Thành on 31/07/2022.
//

import UIKit

class NoteViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topContentView: UIView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    
    var lastTableScrollOffset: CGFloat = 0
    var notes: NoteModels = [] {
        didSet {
            let userDefaults = UserDefaults.standard
            do {
                try userDefaults.setObject(notes, forKey: "NoteModels")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    var sections: TableSections = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func setupUI() {
        super.setupUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: tableView.bounds.size.width - 8.0)
        let userDefaults = UserDefaults.standard
        do {
            notes = try userDefaults.getObject(forKey: "NoteModels", castTo: NoteModels.self)
            if notes.first(where: {$0.createDate == Date().string()}) == nil {
                self.notes.append(NoteModel(createDate: Date().string()))
            }
        } catch {
            if let error_ = error as? ObjectSavableError, error_ == .noValue {
                self.notes.append(NoteModel(createDate: Date().string()))
            }
            print(error.localizedDescription)
        }
        self.prepareItems(notes)
    }
    
    fileprivate func prepareItems(_ notes: NoteModels) {
        self.sections.removeAll()
        var newSections: TableSections = []
        for note in notes {
            let header: HeaderNoteView = HeaderNoteView()
            header.setData(date: note.createDate)
            let bodyCell: TableItem = (ContentNoteCell.self, note)
            newSections.append((header, 40, [bodyCell]))
        }
        self.sections = newSections.reversed()
        self.tableView.reloadData()
    }
    
    func reloadData() {
        self.prepareItems(self.notes)
    }
}

extension NoteViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.section]
        let item = section.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(with: item.cellType)
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        if let dataCell = cell as? CellDataProtocol {
            dataCell.setData(item.data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = self.sections[section]
        return section.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let section = self.sections[section]
        section.header?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        return section.header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ContentNoteCell {
            if cell.note?.createDate == Date().string() {
                let entryView = UIStoryboard.instantiate(name: "Note", EntryViewController.self)
                entryView.noteModel = cell.note
                entryView.completion = {[weak self] noteModel in
                    if let noteModel = noteModel, let index = self?.notes.firstIndex(where: {$0.createDate == noteModel.createDate}) {
                        self?.notes[index] = noteModel
                        self?.reloadData()
                    }
                    self?.navigationController?.dismiss(animated: true)
                }
                navigationController?.present(entryView, animated: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 10 {
            self.topContentView.isHidden = false
            self.topViewHeight.constant = 56
        } else {
            if !self.topContentView.isHidden {
                self.topContentView.isHidden = true
                self.topViewHeight.constant = 0
            }
        }
    }
}
