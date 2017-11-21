import UIKit
import XCTest
import SlideController

class LoadTests: BaseTestCase {
    
    func testLoadOnContentUnloadingEnabled() {
        slideController.isContentUnloadingEnabled = true
        let page1 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        guard let object1 = page1.lifeCycleObject as? TestableLifeCycleObject,
            let object2 = page2.lifeCycleObject as? TestableLifeCycleObject,
            let object3 = page3.lifeCycleObject as? TestableLifeCycleObject else {
            XCTFail("page is not TestableLifeCycleObject")
            return
        }
        
        XCTAssert(object1.viewDidLoadTriggered)
        XCTAssert(object2.viewDidLoadTriggered)
        XCTAssert(!object3.viewDidLoadTriggered)
    }
    
    func testLoadOnContentUnloadingDisabled() {
        slideController.isContentUnloadingEnabled = false
        let page1 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        guard let object1 = page1.lifeCycleObject as? TestableLifeCycleObject,
            let object2 = page2.lifeCycleObject as? TestableLifeCycleObject,
            let object3 = page3.lifeCycleObject as? TestableLifeCycleObject else {
                XCTFail("page is not TestableLifeCycleObject")
                return
        }
        
        XCTAssert(object1.viewDidLoadTriggered)
        XCTAssert(object2.viewDidLoadTriggered)
        XCTAssert(object3.viewDidLoadTriggered)
    }
    
    func testContentUnloadingModeChangeToDisabled() {
        slideController.isContentUnloadingEnabled = true
        let page1 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        slideController.isContentUnloadingEnabled = false
        
        guard let object1 = page1.lifeCycleObject as? TestableLifeCycleObject,
            let object2 = page2.lifeCycleObject as? TestableLifeCycleObject,
            let object3 = page3.lifeCycleObject as? TestableLifeCycleObject else {
                XCTFail("page is not TestableLifeCycleObject")
                return
        }
        
        XCTAssert(object1.viewDidLoadTriggered)
        XCTAssert(object2.viewDidLoadTriggered)
        XCTAssert(object3.viewDidLoadTriggered)
    }
    
    func testContentUnloadingModeChangeToEnabled() {
        slideController.isContentUnloadingEnabled = false
        let page1 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        slideController.isContentUnloadingEnabled = true
        
        guard let object1 = page1.lifeCycleObject as? TestableLifeCycleObject,
            let object2 = page2.lifeCycleObject as? TestableLifeCycleObject,
            let object3 = page3.lifeCycleObject as? TestableLifeCycleObject else {
                XCTFail("page is not TestableLifeCycleObject")
                return
        }
        
        XCTAssert(!object1.viewDidUnloadTriggered)
        XCTAssert(!object2.viewDidUnloadTriggered)
        XCTAssert(object3.viewDidUnloadTriggered)
    }
    
    func testInsertOnContentLoadingModeDisabled() {
        slideController.isContentUnloadingEnabled = false
        let page1 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        let insertingPage = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        slideController.insert(object: insertingPage, index: 0)
        
        guard let insertingObject = insertingPage.lifeCycleObject as? TestableLifeCycleObject,
            let object1 = page1.lifeCycleObject as? TestableLifeCycleObject,
            let object2 = page2.lifeCycleObject as? TestableLifeCycleObject,
            let object3 = page3.lifeCycleObject as? TestableLifeCycleObject else {
                XCTFail("page is not TestableLifeCycleObject")
                return
        }
        
        XCTAssert(insertingObject.viewDidLoadTriggered)
        XCTAssert(!insertingObject.viewDidUnloadTriggered)
        XCTAssert(!object1.viewDidUnloadTriggered)
        XCTAssert(!object2.viewDidUnloadTriggered)
        XCTAssert(!object3.viewDidUnloadTriggered)
    }
    
    func testAppendOnContentLoadingModeDisabled() {
        slideController.isContentUnloadingEnabled = false
        let page1 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        let appendingPage = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        slideController.insert(object: appendingPage, index: 2)
        
        guard let appendingObject = appendingPage.lifeCycleObject as? TestableLifeCycleObject,
            let object1 = page1.lifeCycleObject as? TestableLifeCycleObject,
            let object2 = page2.lifeCycleObject as? TestableLifeCycleObject,
            let object3 = page3.lifeCycleObject as? TestableLifeCycleObject else {
                XCTFail("page is not TestableLifeCycleObject")
                return
        }
        
        XCTAssert(appendingObject.viewDidLoadTriggered)
        XCTAssert(!appendingObject.viewDidUnloadTriggered)
        XCTAssert(!object1.viewDidUnloadTriggered)
        XCTAssert(!object2.viewDidUnloadTriggered)
        XCTAssert(!object3.viewDidUnloadTriggered)
    }
}
