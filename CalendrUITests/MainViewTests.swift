//
//  MainViewTests.swift
//  CalendrUITests
//
//  Created by Paker on 14/07/2021.
//

import XCTest

class MainViewTests: UITestCase {

    func testMainStatusItemClicked_shouldDisplayMainView() {

        MenuBar.main.click()

        XCTAssertTrue(Main.view.didAppear)
        XCTAssertTrue(Main.pinBtn.isHittable)

        Main.view.outside.click()

        XCTAssertFalse(Main.pinBtn.isHittable)
    }

    func testPinButtonClicked_withEscapeKey_shouldNotHideMainView() {

        MenuBar.main.click()

        XCTAssertTrue(Main.view.didAppear)

        Main.pinBtn.click()
        Main.view.typeKey(.escape, modifierFlags: [])
        XCTAssertTrue(Main.pinBtn.isHittable)

        Main.pinBtn.click()
        Main.view.typeKey(.escape, modifierFlags: [])

        XCTAssertFalse(Main.pinBtn.isHittable)
    }

    func testPinButtonClicked_shouldNotHideMainView() {

        MenuBar.main.click()

        XCTAssertTrue(Main.view.didAppear)

        Main.pinBtn.click()
        Main.view.outside.click()

        XCTAssertTrue(Main.pinBtn.isHittable)

        app.activate()

        Main.pinBtn.click()
        Main.view.outside.click()

        XCTAssertFalse(Main.pinBtn.isHittable)
    }

    func testEventStatusItemClicked_shouldDisplayEventDetails() {

        MenuBar.event.wait(.eventTimeout).click()

        XCTAssertTrue(EventDetails.view.didAppear)

        EventDetails.view.outside.click()

        XCTAssertFalse(EventDetails.view.exists)
    }

    func testRemindersButtonClicked_shouldOpenRemindersApp() {

        let reminders = XCUIApplication(
            url: NSWorkspace.shared.urlForApplication(toOpen: URL(string: "x-apple-reminderkit://")!)!
        )

        MenuBar.main.click()

        XCTAssertTrue(Main.view.didAppear)

        Main.remindersBtn.click()

        XCTAssert(app.wait(for: .runningBackground, timeout: 1))
        XCTAssert(reminders.wait(for: .runningForeground, timeout: 1))

        reminders.terminate()
    }

    func testCalendarButtonClicked_shouldOpenCalendarApp() {

        let calendar = XCUIApplication(url: NSWorkspace.shared.urlForApplication(toOpen: URL(string: "webcal://")!)!)

        MenuBar.main.click()

        XCTAssertTrue(Main.view.didAppear)

        Main.calendarBtn.click()

        XCTAssert(app.wait(for: .runningBackground, timeout: 1))
        XCTAssert(calendar.wait(for: .runningForeground, timeout: 1))

        calendar.terminate()
    }

    func testSettingsMenu_withPickerMenuItemHovered_shouldOpenCalendarPicker() {

        MenuBar.main.click()
        Main.settingsBtn.click()
        Main.settingsBtn.menuItem("Calendars").hover()

        XCTAssertTrue(CalendarPicker.view.didAppear)

        CalendarPicker.view.outside.click()

        XCTAssertFalse(CalendarPicker.view.exists)
    }

    func testSettingsMenu_withPreferencesMenuItemClicked_shouldOpenSettings() {

        MenuBar.main.click()
        Main.settingsBtn.click()
        Main.settingsBtn.menuItem("Preferences").click()

        XCTAssertTrue(Settings.window.didAppear)
        XCTAssertTrue(Settings.view.didAppear)

        Settings.window.buttons[XCUIIdentifierCloseWindow].click()

        XCTAssertFalse(Settings.window.exists)
    }

    func testSettingsMenu_withQuitMenuItemClicked_shouldCloseApp() {

        MenuBar.main.click()
        Main.settingsBtn.click()
        Main.settingsBtn.menuItem("Quit").click()

        XCTAssert(app.wait(for: .notRunning, timeout: 1))
    }

    func testSettingsMenu_withSearchMenuItemClicked_shouldShowSearchInput() {

        MenuBar.main.click()
        XCTAssertFalse(Main.searchInput.exists)

        Main.settingsBtn.click()
        Main.settingsBtn.menuItem("Search").click()

        XCTAssertTrue(Main.searchInput.exists)
        XCTAssertTrue(Main.searchInput.hasFocus)
    }

    func testSearch_withKeyboardShortcut_shouldShowSearchInput() {

        MenuBar.main.click()
        XCTAssertFalse(Main.searchInput.exists)

        Main.view.typeKey("f", modifierFlags: [.command])
        XCTAssertTrue(Main.searchInput.exists)
        XCTAssertTrue(Main.searchInput.hasFocus)
    }

    func testSearch_withEscapeKey_withSearchFieldFocused_shouldHideSearchInput() {

        MenuBar.main.click()
        Main.view.typeKey("f", modifierFlags: [.command])
        XCTAssertTrue(Main.searchInput.exists)
        XCTAssertTrue(Main.searchInput.hasFocus)

        Main.view.typeKey(.escape, modifierFlags: [])
        XCTAssertFalse(Main.searchInput.exists)

        // ensure main view is still visible
        XCTAssertTrue(Main.pinBtn.isHittable)
    }
}
