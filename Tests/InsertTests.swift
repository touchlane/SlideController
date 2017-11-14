import UIKit
import XCTest
import SlideController

class InsertTests: BaseTestCase {
    
    func testInserted() {
        let page1 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        let insertingPage = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        slideController.insert(object: insertingPage, index: 0)
        
        let contentCount = slideController.content.count
        let currentIndex = slideController.content.index(where: { $0 === slideController.currentModel })

        XCTAssertEqual(contentCount, givenContent.count + 1)
        XCTAssertEqual(currentIndex, 1)
    }
    
    func testInsertedAtFirstLifeCycle() {
        let page1 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2]
        slideController.append(object: givenContent)
        
        let insertingPage = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        slideController.insert(object: insertingPage, index: 0)
        
        guard let insertingObject = insertingPage.lifeCycleObject as? TestableLifeCycleObject else {
            XCTFail("page is not TestableLifeCycleObject")
            return
        }
        
        XCTAssert(!insertingObject.didAppearTriggered)
        XCTAssert(!insertingObject.didDissapearTriggered)
        XCTAssert(insertingObject.viewDidLoadTriggered)
        XCTAssert(!insertingObject.viewDidUnloadTriggered)
        XCTAssert(!insertingObject.didStartSlidingTriggered)
        XCTAssert(!insertingObject.didCancelSlidingTriggered)
    }
    
    func testInsertedAtLastLifeCycle() {
        let page1 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2]
        slideController.append(object: givenContent)
        
        let insertingPage = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        slideController.insert(object: insertingPage, index: slideController.content.count - 1)
        
        guard let insertingObject = insertingPage.lifeCycleObject as? TestableLifeCycleObject else {
            XCTFail("page is not TestableLifeCycleObject")
            return
        }
        
        XCTAssert(!insertingObject.didAppearTriggered)
        XCTAssert(!insertingObject.didDissapearTriggered)
        XCTAssert(!insertingObject.viewDidLoadTriggered)
        XCTAssert(!insertingObject.viewDidUnloadTriggered)
        XCTAssert(!insertingObject.didStartSlidingTriggered)
        XCTAssert(!insertingObject.didCancelSlidingTriggered)
    }
}
