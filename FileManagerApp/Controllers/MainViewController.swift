//
//  ViewController.swift
//  FileManagerApp
//
//  Created by Алина Бондарчук on 12.06.2022.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var arrangeBarButtonItem: UIBarButtonItem!
    
    var files = [File]()
    var parentFiles = [File]()
    var isTapped = false
    var selectedDirectory = "" {
        didSet {
            self.navigationItem.backButtonTitle = selectedDirectory
        }
    }
        
    lazy var collectionViewFlowLayout : CustomCollectionViewFlowLayout = {
            let layout = CustomCollectionViewFlowLayout(display: .list)
            return layout
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        loadFiles()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard let destination = segue.destination as? ChildViewController else { return }
            destination.delegate = self
        }

    @IBAction func changeLayoutValue(_ sender: Any) {
        isTapped = !isTapped
        arrangeBarButtonItem.image = isTapped ? Constants.gridBarButtonItem : Constants.listBarButtonItem
        self.collectionViewFlowLayout.display = isTapped ? .grid : .list
        self.collectionView.reloadData()
    }
    
    @IBAction func createNewFileAction(_ sender: Any) {
        let ac = UIAlertController(title: "Create new file", message: nil, preferredStyle: .alert)
        ac.addTextField  { (textfield) in
            textfield.placeholder = "Enter new name here"
        }
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [self] _ in
            let textField = ac.textFields![0] as UITextField
            guard textField.text != "" else { return }
            let newEntry = File(id: UUID().uuidString, parentId: "", type: "f", name: textField.text! + ".txt")
            files.append(newEntry)
            getCurrentData()
            collectionView.reloadData()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(ac, animated: true)
    }
    
    @IBAction func createNewDirectoryAction(_ sender: Any) {
        let ac = UIAlertController(title: "Create new directory", message: nil, preferredStyle: .alert)
        ac.addTextField  { (textfield) in
            textfield.placeholder = "Enter new name here"
        }
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [self] _ in
            let textField = ac.textFields![0] as UITextField
            guard textField.text != "" else { return }
            let newEntry = File(id: UUID().uuidString, parentId: "", type: "d", name: textField.text!)
            files.append(newEntry)
            getCurrentData()
            collectionView.reloadData()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(ac, animated: true)
    }
    
    func loadFiles() {
        FetchAPI.sharedApi.fetchAPI { files, error in
            if let files = files {
                self.files = files
                self.getCurrentData()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setCollectionView() {
        self.collectionView.register(UINib(nibName: GridCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: GridCollectionViewCell.id)
        self.collectionView.register(UINib(nibName: ListCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: ListCollectionViewCell.id)
        self.collectionView.collectionViewLayout = self.collectionViewFlowLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func getCurrentData() {
        let newData = files.filter {
            $0.parentId == "" && $0.id != ""
        }
        parentFiles = newData
        parentFiles.sort { $0.type < $1.type }
        self.collectionView.reloadData()
    }
}

extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parentFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let file = parentFiles[indexPath.item]
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        
        guard parentFiles[indexPath.item].type == "d" else { return }
        guard let vc = self.storyboard?.instantiateViewController(identifier: ChildViewController.id) as? ChildViewController else { return }
        vc.files = files
        vc.delegate = self
        vc.parentUUID = parentFiles[indexPath.item].id
        vc.collectionDisplay = self.collectionViewFlowLayout.display
        selectedDirectory = parentFiles[indexPath.item].name
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, state: .off) { [self] _ in
            if files.contains(parentFiles[indexPath.item]) {
                files.removeAll(where: {$0 == parentFiles[indexPath.item]})
                getCurrentData()
                self.collectionView.reloadData()
                print(files.count)
            }
        }
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return UIMenu(title: "", children: [delete])
        }
        
        return configuration
        
    }
}

extension MainViewController: UpdateDataProtocol {
    func update(files: [File]) {
        self.files = files
        self.collectionView.reloadData()
    }
}

