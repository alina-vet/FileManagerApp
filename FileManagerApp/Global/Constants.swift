//
//  Constants.swift
//  FileManagerApp
//
//  Created by Алина Бондарчук on 12.06.2022.
//

import Foundation
import UIKit

class Constants {
    
    static let keyGoogleSheetId: String = "1z_IyGMnkojr-t6jMgxY2v-7OnDjfm49_mUgMu5qOrIU"
    static let keyGoogleApiKey: String = "AIzaSyCFXjc3EjfDoE9iZ8kY8SUdxYsebFvk_7s#"
    
    static let keyURL = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(Constants.keyGoogleSheetId)/values/Sheet1!A:D?key=\(Constants.keyGoogleApiKey)")
    
    static let directoryImage = UIImage(systemName: "doc.text.fill")
    static let fileImage = UIImage(systemName: "folder.fill")
    static let gridBarButtonItem = UIImage(systemName: "square.grid.2x2")
    static let listBarButtonItem = UIImage(systemName: "list.dash")
}
