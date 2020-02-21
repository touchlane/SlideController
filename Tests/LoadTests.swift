import SlideController
import UIKit
import XCTest

class LoadTests: BaseTestCase {
    func testLoadOnContentUnloadingEnabled() {
        slideController.isContentUnloadingEnabled = true
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
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
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
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
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
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
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
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
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)

        let insertingPage = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
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
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)

        let appendingPage = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
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
