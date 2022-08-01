//
//  UIView+Extension.swift
//  ShowWeb
//
//  Created by Nam Nguyễn Thành on 20/07/2022.
//

import Foundation
import UIKit
import WebKit

extension WKWebView {
    class func clearCache() {
        URLCache.shared.removeAllCachedResponses()
        
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("[LOG] WebCacheCleaner-All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("[LOG] WebCacheCleaner-Record \(record) deleted")
            }
        }
    }
}
