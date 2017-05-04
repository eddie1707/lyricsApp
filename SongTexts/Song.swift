//
//  Song.swift
//  SongTexts
//
//  Created by Edwin Wiersma on 04/05/2017.
//  Copyright © 2017 Apps4mobile. All rights reserved.
//

import Foundation
import Firebase

struct Song {
    
    let key: String
    let title: String
    let text: String
    
    init(key: String, title: String, text: String) {
        self.key = key
        self.title = title
        self.text = text
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        title = snapshotValue["Title"] as! String
        text = snapshotValue["Text"] as! String
    }
    
    func toAnyObject() -> Any {
        return [
            "Title": title,
            "Text": text
        
        ]
    }
    
}
