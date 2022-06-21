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
    var createNewFileButton: UIBarButtonItem!
    var createNewDirectoryButton: UIBarButtonItem!
        
    weak var delegate: UpdateDataProtocol?
    
    lazy var collectionViewFlowLayout : CustomCollectionViewFlowLayout = {
        let layout = CustomCollectionViewFlowLayout(display: collectionDisplay)
            return layout
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        setNavigationBar()
        getChildData()
    }
    
    func setCollectionView() {
        self.collectionView.register(UINib(nibName: GridCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: GridCollectionViewCell.id)
        self.collectionView.register(UINib(nibName: ListCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: ListCollectionViewCell.id)
        self.collectionView.collectionViewLayout = self.collectionViewFlowLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func setNavigationBar() {
        self.navigationItem.rightBarButtonItem = nil
        createNewDirectoryButton = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(createNewDirectoryAction))
        createNewFileButton = UIBarButtonItem(image: UIImage(systemName: "doc.badge.plus"), style: .plain, target: self, action: #selector(createNewFileAction))
        self.navigationItem.rightBarButtonItems = [createNewDirectoryButton, createNewFileButton]
    }
    
    func getChildData() {
        let newData = files.filter {
            $0.parentId == self.parentUUID && $0.id != ""
        }
        childFiles = newData
        childFiles.sort { $0.type < $1.type }
        self.collectionView.reloadData()
    }
    
    @objc func createNewDirectoryAction() {
        let ac = UIAlertController(title: "Create new directory", message: nil, preferredStyle: .alert)
        ac.addTextField  { (textfield) in
            textfield.placeholder = "Enter new name here"
        }
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [self] _ in
            let textField = ac.textFields![0] as UITextField
            guard textField.text != "" else{return}
            let newEntry = File(id: UUID().uuidString, parentId: parentUUID, type: "d", name: textField.text!)
            files.append(newEntry)
            delegate?.update(files: files)
            getChildData()
            collectionView.reloadData()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(ac, animated: true)
    }
    
    @objc func createNewFileAction() {
        let ac = UIAlertController(title: "Create new file", message: nil, preferredStyle: .alert)
        ac.addTextField  { (textfield) in
            textfield.placeholder = "Enter new name here"
        }
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [self] _ in
            let textField = ac.textFields![0] as UITextField
            guard textField.text != "" else { return }
            let newEntry = File(id: UUID().uuidString, parentId: parentUUID, type: "f", name: textField.text! + ".txt")
            files.append(newEntry)
            delegate?.update(files: files)
            getChildData()
            collectionView.reloadData()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(ac, animated: true)
    }
}

extension ChildViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let file = childFiles[indexPath.item]
        
        switch collectionViewFlowLayout.display {
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.id, for: indexPath) as! ListCollectionViewCell
                cell.file = file
            return cell
        case .grid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.id, for: indexPath) as! GridCollectionViewCell
                cell.file = file
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, state: .off) { [self] _ in
            if files.contains(childFiles[indexPath.item]) {
                files.removeAll(where: {$0 == childFiles[indexPath.item]})
                getChildData()
                delegate?.update(files: files)
                collectionView.reloadData()
                print(files.count)
            }
        }
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return UIMenu(title: "", children: [delete])
        }
        return configuration
    }
}
