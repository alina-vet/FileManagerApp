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
    @IBOutlet weak var createNewDirectoryButton: UIBarButtonItem!
    
    var files = [File]()
    var parentFiles = [File]()
    var selectedDirectory = "" {
        didSet {
            self.navigationItem.backButtonTitle = selectedDirectory
        }
    }
    var isTapped = false
        
    lazy var collectionViewFlowLayout : CustomCollectionViewFlowLayout = {
            let layout = CustomCollectionViewFlowLayout(display: .list)
            return layout
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: GridCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: GridCollectionViewCell.id)
        self.collectionView.register(UINib(nibName: ListCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: ListCollectionViewCell.id)
        self.collectionView.collectionViewLayout = self.collectionViewFlowLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
                
        loadFiles()
    }

    @IBAction func changeLayoutValue(_ sender: Any) {
        isTapped = !isTapped
        arrangeBarButtonItem.image = isTapped ? Constants.gridBarButtonItem : Constants.listBarButtonItem
        self.collectionViewFlowLayout.display = isTapped ? .grid : .list
        self.collectionView.reloadData()
    }
    
    @IBAction func createNewDirectoryAction(_ sender: Any) {
        let ac = UIAlertController(title: "Create", message: nil, preferredStyle: .alert)
        ac.addTextField  { (textfield) in
            textfield.placeholder = "Enter new name here"
        }
        ac.addAction(UIAlertAction(title: "new directory", style: .default, handler: { _ in
            let textField = ac.textFields![0] as UITextField
            guard textField.text != "" else{return}
            var newEntry = File(id: UUID().uuidString, parentId: "", type: "d", name: textField.text!)
            self.updateData(entry: newEntry)
            self.collectionView.reloadData()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(ac, animated: true)
    }
    
    func updateData(entry: File){
        FetchAPI.sharedApi.putAPI  { files, error in
            if files != nil {
                self.files.append(entry)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        
        guard parentFiles[indexPath.item].type == "d" else { return }
        guard let vc = self.storyboard?.instantiateViewController(identifier: ChildViewController.id) as? ChildViewController else { return }
        vc.parentUUID = parentFiles[indexPath.item].id
        vc.collectionDisplay = self.collectionViewFlowLayout.display
        selectedDirectory = parentFiles[indexPath.item].name
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

