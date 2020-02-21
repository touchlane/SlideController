import SlideController
import UIKit
import XCTest

class InsertTests: BaseTestCase {
    func testInserted() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)

        let insertingPage = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        slideController.insert(object: insertingPage, index: 0)

        let contentCount = slideController.content.count
        let currentIndex = slideController.content.firstIndex(where: { $0 === slideController.currentModel })

        XCTAssertEqual(contentCount, givenContent.count + 1)
        XCTAssertEqual(currentIndex, 1)
    }

    func testInsertedAtFirstLifeCycle() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2]
        slideController.append(object: givenContent)

        let insertingPage = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        slideController.insert(object: insertingPage, index: 0)

        guard let insertingObject = insertingPage.lifeCycleObject as? TestableLifeCycleObject,
            let object1 = page1.lifeCycleObject as? TestableLifeCycleObject,
            let object2 = page2.lifeCycleObject as? TestableLifeCycleObject else {
            XCTFail("page is not TestableLifeCycleObject")
            return
        }

        XCTAssert(!insertingObject.didAppearTriggered)
        XCTAssert(!insertingObject.didDissapearTriggered)
        XCTAssert(insertingObject.viewDidLoadTriggered)
        XCTAssert(!insertingObject.viewDidUnloadTriggered)
        XCTAssert(!insertingObject.didStartSlidingTriggered)
        XCTAssert(!insertingObject.didCancelSlidingTriggered)

        XCTAssert(object1.didAppearTriggered)
        XCTAssert(!object1.didDissapearTriggered)
        XCTAssert(object1.viewDidLoadTriggered)
        XCTAssert(!object1.viewDidUnloadTriggered)
        XCTAssert(!object1.didStartSlidingTriggered)
        XCTAssert(!object1.didCancelSlidingTriggered)

        XCTAssert(!object2.didAppearTriggered)
        XCTAssert(!object2.didDissapearTriggered)
        XCTAssert(object2.viewDidLoadTriggered)
        XCTAssert(!object2.viewDidUnloadTriggered)
        XCTAssert(!object2.didStartSlidingTriggered)
        XCTAssert(!object2.didCancelSlidingTriggered)
    }

    func testInsertedAtLastLifeCycle() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2]
        slideController.append(object: givenContent)

        let insertingPage = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        slideController.insert(object: insertingPage, index: slideController.content.count - 1)

        guard let insertingObject = insertingPage.lifeCycleObject as? TestableLifeCycleObject,
            let object1 = page1.lifeCycleObject as? TestableLifeCycleObject,
            let object2 = page2.lifeCycleObject as? TestableLifeCycleObject else {
            XCTFail("page is not TestableLifeCycleObject")
            return
        }

        XCTAssert(!insertingObject.didAppearTriggered)
        XCTAssert(!insertingObject.didDissapearTriggered)
        XCTAssert(insertingObject.viewDidLoadTriggered)
        XCTAssert(!insertingObject.viewDidUnloadTriggered)
        XCTAssert(!insertingObject.didStartSlidingTriggered)
        XCTAssert(!insertingObject.didCancelSlidingTriggered)

        XCTAssert(object1.didAppearTriggered)
        XCTAssert(!object1.didDissapearTriggered)
        XCTAssert(object1.viewDidLoadTriggered)
        XCTAssert(!object1.viewDidUnloadTriggered)
        XCTAssert(!object1.didStartSlidingTriggered)
        XCTAssert(!object1.didCancelSlidingTriggered)

        XCTAssert(!object2.didAppearTriggered)
        XCTAssert(!object2.didDissapearTriggered)
        XCTAssert(object2.viewDidLoadTriggered)
        XCTAssert(object2.viewDidUnloadTriggered)
        XCTAssert(!object2.didStartSlidingTriggered)
        XCTAssert(!object2.didCancelSlidingTriggered)
    }

    func testInsertedBeforeCurrentLifeCycle() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2]
        slideController.append(object: givenContent)
        slideController.shift(pageIndex: 1, animated: false)

        let insertingPage = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        slideController.insert(object: insertingPage, index: 0)

        guard let insertingObject = insertingPage.lifeCycleObject as? TestableLifeCycleObject,
            let object1 = page1.lifeCycleObject as? TestableLifeCycleObject,
            let object2 = page2.lifeCycleObject as? TestableLifeCycleObject else {
            XCTFail("page is not TestableLifeCycleObject")
            return
        }

        XCTAssert(!insertingObject.didAppearTriggered)
        XCTAssert(!insertingObject.didDissapearTriggered)
        XCTAssert(!insertingObject.viewDidLoadTriggered)
        XCTAssert(!insertingObject.viewDidUnloadTriggered)
        XCTAssert(!insertingObject.didStartSlidingTriggered)
        XCTAssert(!insertingObject.didCancelSlidingTriggered)

        XCTAssert(object1.didAppearTriggered)
        XCTAssert(object1.didDissapearTriggered)
        XCTAssert(object1.viewDidLoadTriggered)
        XCTAssert(!object1.viewDidUnloadTriggered)
        XCTAssert(!object1.didStartSlidingTriggered)
        XCTAssert(!object1.didCancelSlidingTriggered)

        XCTAssert(object2.didAppearTriggered)
        XCTAssert(!object2.didDissapearTriggered)
        XCTAssert(object2.viewDidLoadTriggered)
        XCTAssert(!object2.viewDidUnloadTriggered)
        XCTAssert(!object2.didStartSlidingTriggered)
        XCTAssert(!object2.didCancelSlidingTriggered)
    }
}
