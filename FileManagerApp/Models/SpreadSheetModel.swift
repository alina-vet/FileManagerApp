//
//  SpreadSheetModel.swift
//  FileManagerApp
//
//  Created by Алина Бондарчук on 12.06.2022.
//

import Foundation

struct SpreadSheetValues: Codable {
    var range: String
    var majorDimension: String
    var values: [[String]]

    func parseFiles() -> [File] {
        var files = [File]()
        
        for value in self.values {
        
            let id = value[0]
            let parentId = value[1]
            let type = value[2]
            let name = value[3]
            
            files.append(File(id: id, parentId: parentId, type: type, name: name))
        }
        
        return files
    }
}
