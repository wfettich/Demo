//
//  TagViewModel_Tests.swift
//  Demo
//
//  Created by Walter Fettich on 09/04/2019.
//  Copyright © 2019 Walter Fettich. All rights reserved.
//

import XCTest

class TagViewModel_Tests: XCTestCase {

    var tags:TagViewModel!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        tags = TagViewModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func test_SetTags()
    {
        let t = Tag(name:"lalala    ",value:"1",category:"test",selected:false,optional:false )
        let t2 = Tag(name:"dodo    ",value:"2",category:"test",selected:false,optional:false )
        let t3 = Tag(name:"more stuff ",value:"3",category:"test",selected:false,optional:false )
        tags.setDataWithoutCallingDelegate([t,t2,t3])
        XCTAssert(tags.count == 3)
        XCTAssert(tags.at(0) == t)
        XCTAssert(tags.at(0)!.orderNumber == 1)
        XCTAssert(tags.at(1) == t2)
        XCTAssert(tags.at(1)!.orderNumber == 2)
        XCTAssert(tags.at(2) == t3)
        XCTAssert(tags.at(2)!.orderNumber == 3)
    }
    
    func test_SetTags_RemoveTag()
    {
        let t = Tag(name:"lalala    ",value:"1",category:"test",selected:false,optional:false )
        let t2 = Tag(name:"dodo    ",value:"2",category:"test",selected:false,optional:false )
        let t3 = Tag(name:"more stuff ",value:"3",category:"test",selected:false,optional:false )
        tags.setDataWithoutCallingDelegate([t,t2,t3])
        XCTAssert(tags.count == 3)
        XCTAssert(tags.at(0) == t)
        XCTAssert(tags.at(0)!.orderNumber == 1)
        XCTAssert(tags.at(1) == t2)
        XCTAssert(tags.at(1)!.orderNumber == 2)
        XCTAssert(tags.at(2) == t3)
        XCTAssert(tags.at(2)!.orderNumber == 3)
        
        _ = tags.remove(tag: t2)
        XCTAssert(tags.count == 2)
        XCTAssertFalse(tags.data.contains(t2))
        XCTAssert(tags.at(1) == t3)
    }
    
    func test_Add_Existing_Tag()
    {
        
    }
    
    func test_Add_Remove_Tag()
    {
        let t = Tag(name:"lalala    ",value:"1",category:"test",selected:false,optional:false )
        let t2 = Tag(name:"dodo    ",value:"2",category:"test",selected:false,optional:false )
        let t3 = Tag(name:"more stuff ",value:"3",category:"test",selected:false,optional:false )
        tags.setDataWithoutCallingDelegate([t,t2,t3])
        XCTAssert(tags.count == 3)
        XCTAssert(tags.at(0) == t)
        XCTAssert(tags.at(0)!.orderNumber == 1)
        XCTAssert(tags.at(1) == t2)
        XCTAssert(tags.at(1)!.orderNumber == 2)
        XCTAssert(tags.at(2) == t3)
        XCTAssert(tags.at(2)!.orderNumber == 3)
        
        let added = Tag(name:"added ",value:"t",category:"test",selected:false,optional:false )
        tags.addTag(tag: added)
        XCTAssert(tags.count == 4)
        XCTAssert(tags.at(3) == added)
        XCTAssert(tags.at(3)!.orderNumber == 4)
        
        _ = tags.remove(tag: t2)
        XCTAssert(tags.count == 3)
        XCTAssert(tags.at(1) == t3)
        
        _ = tags.remove(tag: added)
        XCTAssert(tags.count == 2)
        XCTAssert(tags.at(1) == t3)
    }
    
    func test_Select_UnselectTags()
    {
        
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
