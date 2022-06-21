//
//  FileCollectionViewCell.swift
//  FileManagerApp
//
//  Created by Алина Бондарчук on 12.06.2022.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    
    static let id = "GridCollectionViewCell"
    
    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    
    var file: File? {
        didSet {
            if let file = file {
                self.fileNameLabel.text = file.name
                self.fileImageView?.image = file.isDirectory ? Constants.fileImage : Constants.directoryImage
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
