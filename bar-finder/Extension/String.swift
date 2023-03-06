//
//  String.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import Foundation

extension String {
    
    var urlEncoded: String {
        self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }

    func localizedStringNear(_ location: String) -> String {
        let localizedString = NSLocalizedString("%@ em %@", comment: "Business name near location")
        return String(format: localizedString, self, location)
    }
    

    func localizedString(withKey key: String, comment: String = "") -> String {
           let localizedString = NSLocalizedString(key, comment: comment)
           return String(format: localizedString, self)
    }
}
