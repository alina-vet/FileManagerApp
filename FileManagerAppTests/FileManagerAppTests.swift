//
//  FileManagerAppTests.swift
//  FileManagerAppTests
//
//  Created by Алина Бондарчук on 12.06.2022.
//

import XCTest
@testable import FileManagerApp

class FileManagerAppTests: XCTestCase {

    var sut: [File]!
    
    override func setUp() {
        sut = [File]()
    }
    
    override func tearDown() {
        sut = nil
    }

    func testInitFileModel() {
        let spreadSheet = File(id: UUID().uuidString, parentId: "", type: "d", name: "Test")
        XCTAssertNotNil(spreadSheet)
    }
    
    func testWhenGivenFileModel() {
        let spreadSheet = File(id: UUID().uuidString, parentId: "", type: "d", name: "Test")
        XCTAssertEqual(spreadSheet.name, "Test")
    }
    
    func testIsNewItemAfolder() {
        let file = File(id: UUID().uuidString, parentId: "", type: "d", name: "Test")
        sut.append(file)
        XCTAssert(file.isDirectory)
    }
    
    func testIsNewItemAfile() {
        let file = File(id: UUID().uuidString, parentId: "", type: "f", name: "Test")
        sut.append(file)
        XCTAssertFalse(file.isDirectory)
    }
    
    func testIsRemoveAllItemA() {
        
        let folder = File(id: UUID().uuidString, parentId: "", type: "d", name: "TestFolder")
        let file = File(id: UUID().uuidString, parentId: "", type: "f", name: "TestFile")
        sut.append(file)
        sut.append(folder)
        let sutCount = sut.count
        XCTAssertEqual(sutCount, sut.count)
        
        sut.removeAll()
        XCTAssertTrue(sut.count == 0)
    }
}
