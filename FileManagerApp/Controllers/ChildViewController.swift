//
//  ChildViewController.swift
//  FileManagerApp
//
//  Created by Алина Бондарчук on 15.06.2022.
//

import UIKit

class ChildViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    static let id = "ChildViewController"
    var files = [File]()
    var childFiles = [File]()
    var parentUUID = ""
    var collectionDisplay: CollectionDisplay = .grid
    
    lazy var collectionViewFlowLayout : CustomCollectionViewFlowLayout = {
        let layout = CustomCollectionViewFlowLayout(display: collectionDisplay)
            return layout
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: GridCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: GridCollectionViewCell.id)
        self.collectionView.register(UINib(nibName: ListCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: ListCollectionViewCell.id)
        self.collectionView.collectionViewLayout = self.collectionViewFlowLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = nil
        
                
        loadFiles()
    }
    
    func loadFiles() {
        FetchAPI.sharedApi.fetchAPI { files, error in
            if let files = files {
                self.files = files
                self.getChildData()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getChildData() {
        let newData = files.filter {
            $0.parentId == self.parentUUID && $0.id != ""
        }
        childFiles = newData
        childFiles.sort { $0.type < $1.type }
        self.collectionView.reloadData()
    }
}

extension ChildViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let file = childFiles[indexPath.item]
        
        if self.collectionViewFlowLayout.display == .list {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.id, for: indexPath) as! ListCollectionViewCell
                cell.file = file
            return cell
            } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.id, for: indexPath) as! GridCollectionViewCell
                cell.file = file
            return cell
        }
    }
}
