//
//  ControllerTests.swift
//  FileManagerAppTests
//
//  Created by Алина Бондарчук on 19.06.2022.
//

import XCTest
@testable import FileManagerApp

class ControllerTests: XCTestCase {

    var sut: MainViewController!
    var collectionView: UICollectionView!
    var controller: MainViewController!

    override func setUp() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyBoard.instantiateViewController(withIdentifier: String(describing: MainViewController.self)) as? MainViewController
        sut = controller
        controller.loadViewIfNeeded()
        collectionView = controller.collectionView
        
        sut.files = [File]()
        sut.parentFiles = [File]()
    }

    override func tearDown() {
        sut = nil
    }

    func testWhenViewsIsLoadedCollectonViewNotNill() {
        XCTAssertNotNil(sut.collectionView)
    }
    
    func testWhenViewsIsLoadedCollectonViewDelegateIsSet() {
        XCTAssertNotNil(sut.collectionView.delegate)
    }
    
    func testWhenViewsIsLoadedCollectonViewDataSourseIsSet() {
        XCTAssertNotNil(sut.collectionView.dataSource)
    }
    
    func testWhenViewsIsLoadedCollectonViewCustomFlowLayoutIsSet() {
        XCTAssertNotNil(sut.collectionViewFlowLayout)
    }
    
    func testNumberOfRowsInSectionZeroIsFileCount() {
        sut.files.append(File(id: UUID().uuidString, parentId: "3", type: "d", name: "Foo1"))
        sut.files.append(File(id: UUID().uuidString, parentId: "3", type: "f", name: "Foo2"))
        sut.files.append(File(id: UUID().uuidString, parentId: "", type: "d", name: "Boo"))
        
        sut.getCurrentData()
        sut.collectionView.reloadData()
        
        XCTAssertEqual(sut.collectionView(collectionView, numberOfItemsInSection: sut.parentFiles.count), 1)
    }

}
