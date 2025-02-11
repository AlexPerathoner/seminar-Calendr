//
//  ContextMenuFactoryTests.swift
//  CalendrTests
//
//  Created by Paker on 18/02/23.
//

import XCTest
import RxSwift
@testable import Calendr

class ContextMenuFactoryTests: XCTestCase {

    let dateProvider = MockDateProvider()
    let calendarService = MockCalendarServiceProvider()
    let workspace = MockWorkspaceServiceProvider()

    func testFactory_isEvent_withInvitationStatus_shouldMakeViewModel() throws {

        for source in [.list, .details] as [ContextMenuSource] {
            for status in [.accepted, .maybe, .pending, .declined] as [EventStatus] {
                let viewModel = try XCTUnwrap(make(event: .make(type: .event(status)), source: source))
                XCTAssert(viewModel is EventOptionsViewModel)
            }
        }
    }

    func testFactory_isEvent_withoutInvitationStatus_withSourceList_shouldMakeViewModel() throws {

        let viewModel = try XCTUnwrap(make(event: .make(type: .event(.unknown)), source: .list))
        XCTAssert(viewModel is EventOptionsViewModel)
    }

    func testFactory_isEvent_withoutInvitationStatus_withSourceDetails_shouldNotMakeViewModel() {

        XCTAssertNil(make(event: .make(type: .event(.unknown)), source: .details))
    }

    func testFactory_isReminder_shouldMakeViewModel() throws {

        for source in [.list, .details] as [ContextMenuSource] {
            let viewModel = try XCTUnwrap(make(event: .make(type: .reminder), source: source))
            XCTAssert(viewModel is ReminderOptionsViewModel)
        }
    }

    func testFactory_isBirthday_withSourceList_shouldMakeViewModel() throws {

        let viewModel = try XCTUnwrap(make(event: .make(type: .birthday), source: .list))
        XCTAssert(viewModel is EventOptionsViewModel)
    }

    func testFactory_isBirthday_withSourceDetails_shouldNotMakeViewModel() {

        XCTAssertNil(make(event: .make(type: .birthday), source: .details))
    }

    func make(event: EventModel, source: ContextMenuSource) -> (any ContextMenuViewModel)? {

        ContextMenuFactory.makeViewModel(
            event: event,
            dateProvider: dateProvider,
            calendarService: calendarService,
            workspace: workspace,
            source: source
        )
    }
}
