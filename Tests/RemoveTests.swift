import UIKit
import XCTest
import SlideController

class RemoveTests: BaseTestCase {
    
    func testRemovedCurrent() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        slideController.removeAtIndex(index: 0)
        
        let contentCount = slideController.content.count
        let currentIndex = slideController.content.firstIndex(where: { $0 === slideController.currentModel })
        
        guard let currentPage = page2.lifeCycleObject as? TestableLifeCycleObject else {
            XCTFail("page is not TestableLifeCycleObject")
            return
        }
        
        XCTAssertEqual(contentCount, givenContent.count - 1)
        XCTAssertEqual(currentIndex, 0)
        XCTAssert(currentPage === slideController.currentModel?.lifeCycleObject)
    }
    
    func testRemovedAll() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        slideController.removeAtIndex(index: 0)
        slideController.removeAtIndex(index: 0)
        slideController.removeAtIndex(index: 0)
        
        let contentCount = slideController.content.count
        
        XCTAssertEqual(contentCount, 0)
        XCTAssertNil(slideController.currentModel)
    }
    
    func testRemovedVisibleLifeCycle() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)

        slideController.removeAtIndex(index: 0)
        
        guard let removedObject = page1.lifeCycleObject as? TestableLifeCycleObject else {
            XCTFail("page is not TestableLifeCycleObject")
            return
        }

        XCTAssert(removedObject.didAppearTriggered)
        XCTAssert(removedObject.didDissapearTriggered)
        XCTAssert(removedObject.viewDidLoadTriggered)
        XCTAssert(removedObject.viewDidUnloadTriggered)
        XCTAssert(!removedObject.didStartSlidingTriggered)
        XCTAssert(!removedObject.didCancelSlidingTriggered)
    }
    
    func testRemovedNearVisibleLifeCycle() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        slideController.removeAtIndex(index: 1)
        
        guard let removedObject = page2.lifeCycleObject as? TestableLifeCycleObject else {
            XCTFail("page is not TestableLifeCycleObject")
            return
        }
        
        XCTAssert(!removedObject.didAppearTriggered)
        XCTAssert(!removedObject.didDissapearTriggered)
        XCTAssert(removedObject.viewDidLoadTriggered)
        XCTAssert(removedObject.viewDidUnloadTriggered)
        XCTAssert(!removedObject.didStartSlidingTriggered)
        XCTAssert(!removedObject.didCancelSlidingTriggered)
    }
    
    func testRemovedFarVisibleLifeCycle() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        slideController.removeAtIndex(index: 2)
        
        guard let removedObject = page3.lifeCycleObject as? TestableLifeCycleObject else {
            XCTFail("page is not TestableLifeCycleObject")
            return
        }
        
        XCTAssert(!removedObject.didAppearTriggered)
        XCTAssert(!removedObject.didDissapearTriggered)
        XCTAssert(!removedObject.viewDidLoadTriggered)
        XCTAssert(!removedObject.viewDidUnloadTriggered)
        XCTAssert(!removedObject.didStartSlidingTriggered)
        XCTAssert(!removedObject.didCancelSlidingTriggered)
    }
}
