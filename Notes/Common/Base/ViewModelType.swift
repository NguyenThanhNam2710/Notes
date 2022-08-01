//
//  ViewModelType.swift
//  NewProject
//
//  Created by Tuan IT. Hoang Anh on 02/06/2022.
//

import Foundation

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
