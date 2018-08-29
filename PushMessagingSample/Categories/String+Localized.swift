//
//  String+Localized.swift
//  PushMessagingSample
//
//  Created by Christina on 8/15/18.
//  Copyright © 2018 Christina. All rights reserved.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Main") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
