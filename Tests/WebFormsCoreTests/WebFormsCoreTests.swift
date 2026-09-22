import XCTest
@testable import WebFormsCore

final class WebFormsCoreTests: XCTestCase {

    func testAddId() {
        let form = WebForms()
        form.addId(InputPlace.tag("div"), "myId")
        XCTAssertEqual(form.getWebFormsData(), "aitagdiv=myId")
    }

    func testSetFontSize() {
        let form = WebForms()
        form.setFontSize(InputPlace.tag("form"), 16)
        XCTAssertEqual(form.getWebFormsData(), "fs<form>=16px")
    }

    func testSetDisabled() {
        let form = WebForms()
        form.setDisabled(InputPlace.name("btn"), true)
        XCTAssertEqual(form.getWebFormsData(), "sd(btn)=1")
    }

    func testResponse() {
        let form = WebForms()
        form.setId(InputPlace.tag("div"), "test")
        XCTAssertEqual(form.response(), "[web-forms]\nsitagdiv=test")
    }

    func testMultipleActions() {
        let form = WebForms()
        form.setId(InputPlace.tag("div"), "id1")
        form.setText(InputPlace.tag("div"), "Hello")
        XCTAssertEqual(form.getWebFormsData(), "sitagdiv=id1\nsttagdiv=Hello")
    }

    func testSecuritySafeValue() {
        let security = Security()
        XCTAssertEqual(security.safeValue("test@value"), "test@value")
        XCTAssertEqual(security.safeValue("@start"), "@@start")
        XCTAssertEqual(security.safeValue("line1\nline2"), "line1$[ln];line2")
    }

    func testChecksum() {
        let form = WebForms()
        form.setId(InputPlace.tag("div"), "test")
        let checksum = form.getChecksum()
        XCTAssertFalse(checksum.isEmpty)
    }

    func testExportToHtmlComment() {
        let form = WebForms()
        form.setId(InputPlace.tag("div"), "test")
        XCTAssertEqual(form.exportToHtmlComment(), "<!--[web-forms]\nsitagdiv=test-->")
    }
}