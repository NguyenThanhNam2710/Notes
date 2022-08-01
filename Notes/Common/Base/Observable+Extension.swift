//
//  Observable+Extension.swift
//  NewProject
//
//  Created by Tuan IT. Hoang Anh on 02/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

public extension ObservableType where Element == Bool {
    /// Boolean not operator
    func not() -> Observable<Bool> {
        return self.map { value -> Bool in
            return !value
        }
    }
}

public extension ObservableType {

    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        /// No need to return a type
        return map { _ in }
    }
}
