@testable import HealthReminder
import XCTest

final class CreateRemindUITests: XCTest {

    func testCreateRemindScreenDynamicFields() {
        
        let app = XCUIApplication()
        app.launch()
        
        let addRemindButton = app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(addRemindButton.exists)
        addRemindButton.tap()
        
        let remindTitleField = app.textFields["Create yout remind"]
        XCTAssertTrue(remindTitleField.exists)
        remindTitleField.tap()
        remindTitleField.typeText("Sample remind")
        
        let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".otherElements[\"UIKeyboardLayoutStar Preview\"]",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,3],[-1,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(returnButton.exists)
        returnButton.tap()
        
        app.children(matching: .window)
            .element(boundBy: 0)
            .children(matching: .other)
            .element(boundBy: 1)
        /*@START_MENU_TOKEN@*/.otherElements["PopoverDismissRegion"]/*[[".otherElements[\"dismiss popup\"]",".otherElements[\"PopoverDismissRegion\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .swipeUp()
        
        let createDefaultRemindButton = app.buttons["Create general remind"]
        XCTAssertTrue(createDefaultRemindButton.exists)
        createDefaultRemindButton.tap()
    }
}
