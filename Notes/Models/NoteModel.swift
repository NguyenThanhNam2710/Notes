//
//  NoteModel.swift
//  Notes
//
//  Created by Nam Nguyễn Thành on 31/07/2022.
//

import Foundation

struct NoteModel: Codable {
    internal init(title: String? = "", note: String? = "", createDate: String) {
        self.title = title
        self.note = note
        self.createDate = createDate
    }
    
    var title: String?
    var note: String?
    var createDate: String
    
}

typealias NoteModels = [NoteModel]
