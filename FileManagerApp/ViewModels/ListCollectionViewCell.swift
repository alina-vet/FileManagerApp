//
//  ListCollectionViewCell.swift
//  FileManagerApp
//
//  Created by Алина Бондарчук on 13.06.2022.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    static let id = "ListCollectionViewCell"
    
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
