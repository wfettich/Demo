//
//  TagViewModel_Tests.swift
//  Demo
//
//  Created by Walter Fettich on 09/04/2019.
//  Copyright © 2019 Walter Fettich. All rights reserved.
//

import XCTest

class TagDelegateReceiver:TagViewModelDelegate
{
    var didCall_dataSetChanged:[Bool] = []
    var didCall_didSelect :[(Tag,Int)] = []
    var didCall_didAddTag :[(Tag,Int)] = []
    
    func dataSetChanged(_ tagController: TagViewModelProtocol)
    {
        didCall_dataSetChanged.append(true)
    }
    
    func didChangeSelection(tag:Tag,atIndex:Int)
    {
        didCall_didSelect.append((tag,atIndex))
    }
    func didAddTag(tag:Tag,atIndex:Int)
    {
        didCall_didAddTag.append((tag,atIndex))
    }
}


class TagViewModel_Tests: XCTestCase {

    var tags:TagViewModelProtocol!
    var tagsDelegate:TagDelegateReceiver!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        tags = TagViewModel()
        tagsDelegate = TagDelegateReceiver()
        tags.delegate = tagsDelegate
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
        XCTAssert(tagsDelegate.didCall_dataSetChanged.count == 0)
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
        XCTAssert(tagsDelegate.didCall_dataSetChanged.count == 0)
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
        XCTAssert(tagsDelegate.didCall_dataSetChanged.count == 1)
    }
    
    func test_Add_Existing_Tag()
    {
        let t = Tag(name:"lalala    ",value:"1",category:"test",selected:false,optional:false )
        let t2 = Tag(name:"dodo    ",value:"2",category:"test",selected:false,optional:false )
        let t3 = Tag(name:"more stuff ",value:"3",category:"test",selected:false,optional:false )
        tags.setDataWithoutCallingDelegate([t,t2,t3])
        XCTAssert(tags.count == 3)
        
        let t4 = Tag(name:"more stuff ",value:"3",category:"test",selected:false,optional:false )
        tags.addTag(tag: t4)
        XCTAssert(tags.count == 3)
        XCTAssert(tags.at(2)! == t4)
        XCTAssert(tags.at(2)! == t3)
        XCTAssert(tags.at(2)!.selected == true)
        XCTAssert(tagsDelegate.didCall_dataSetChanged.count >= 1)
        XCTAssert(tagsDelegate.didCall_didSelect.contains{$0 == (t3,2)})
        
        XCTAssert(tags.selectedTags() == [t3])
        
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
        tags.multiSelect = true
        let t = Tag(name:"one",value:"1",category:"test",selected:false,optional:false )
        let t2 = Tag(name:"two",value:"2",category:"test",selected:false,optional:false )
        let t3 = Tag(name:"three",value:"3",category:"test",selected:false,optional:false )
        let t4 = Tag(name:"four",value:"4",category:"test",selected:false,optional:false )
        tags.setDataWithoutCallingDelegate([t,t2,t3,t4])
        XCTAssert(tags.count == 4)
        
        tags.setSelected(tags: [t,t3])
        XCTAssert(tags.selectedTags().contains(t))
        XCTAssert(tags.selectedTags().contains(t3))
        XCTAssertFalse(tags.selectedTags().contains(t2))
        XCTAssertFalse(tags.selectedTags().contains(t4))
        XCTAssert(tagsDelegate.didCall_didSelect.contains{$0 == (t,0)})
        XCTAssert(tagsDelegate.didCall_didSelect.contains{$0 == (t2,1)})
        XCTAssert(tagsDelegate.didCall_didSelect.contains{$0 == (t3,2)})
        XCTAssert(tagsDelegate.didCall_didSelect.contains{$0 == (t4,3)})
        XCTAssert(tagsDelegate.didCall_dataSetChanged.count == 1)
        
    }
    
    func test_OnylOneSelection()
    {
        tags.multiSelect = false
        let t = Tag(name:"one",value:"1",category:"test",selected:false,optional:false )
        let t2 = Tag(name:"two",value:"2",category:"test",selected:false,optional:false )
        let t3 = Tag(name:"three",value:"3",category:"test",selected:false,optional:false )
        let t4 = Tag(name:"four",value:"4",category:"test",selected:false,optional:false )
        tags.setDataWithoutCallingDelegate([t,t2,t3,t4])
        XCTAssert(tags.count == 4)
        
        tags.setSelected(tags: [t,t3])
        XCTAssert(tagsDelegate.didCall_dataSetChanged.count == 1)
        XCTAssertFalse(tags.selectedTags().count == 1)
    }
    
    
    func test_setCategory()
    {
        
    }
    
    
    
    //test delegates

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
