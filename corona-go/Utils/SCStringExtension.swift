//
//  StringExtension.swift
//  solocoin
//
//  Created by indie dev on 27/03/20.
//

import Foundation

private let customAllowedSet = CharacterSet(charactersIn:"+@-")

extension String {
    
        /**
         Swift 2 friendly localization syntax, replaces NSLocalizedString
         - Returns: The localized string.
         */
       func localized(lang:String) -> String {
            if let path = Bundle.main.path(forResource: lang, ofType: "lproj"), let bundle = Bundle(path: path) {
                return bundle.localizedString(forKey: self, value: nil, table: nil)
            }
            return self
        }
    
    func localized() -> String
    {
        return self.localized(lang: UserDefaults.standard.object(forKey: "language") as! String)
    }
    
    func validateAndEncodeUrl() -> String {
        return (self as NSString).validateAndEncodeUrl() as String
    }
}

extension NSString {
    
    func validateAndEncodeUrl() -> NSString {
        var urlCompoments = self.components(separatedBy: "?")
        if urlCompoments.count <= 1 {
          return self
        }
        guard  let query = urlCompoments.last else {
            return self
        }
        guard var queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return ""
        }
        if queryEncoded.rangeOfCharacter(from: customAllowedSet) != nil {
            queryEncoded = queryEncoded.addingPercentEncoding(withAllowedCharacters: customAllowedSet.inverted)!
        }
        urlCompoments.removeLast()
        urlCompoments.append(queryEncoded)
        return NSString(string: urlCompoments.joined(separator: "?"))
    }
    
}
