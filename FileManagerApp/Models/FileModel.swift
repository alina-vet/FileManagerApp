//
//  File.swift
//  FileManagerApp
//
//  Created by Алина Бондарчук on 12.06.2022.
//

import Foundation

class File: Equatable {
    
    var id: String
    var parentId: String
    var type: String
    var name: String
    
    init(id: String, parentId: String, type: String, name: String) {
        self.id = id
        self.parentId = parentId
        self.type = type
        self.name = name
    }
    
    var isDirectory: Bool {
        return self.type == "d"
    }
    
    static func == (lhs: File, rhs: File) -> Bool {
        return lhs.id == rhs.id
    }
}
