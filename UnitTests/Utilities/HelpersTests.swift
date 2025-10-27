//
//  HelpersTests.swift
//  UnitTests
//


import Foundation
import Testing
@testable import SingerApp

@Suite struct HelpersTests {

    @Test func localizedDefaultLocale() {
        let sut = "Countries".localized(Locale.backendDefault)
        #expect(sut == "Countries")
    }

    @Test func localizedKnownLocale() {
        let sut = "Countries".localized(Locale(identifier: "de"))
        #expect(sut == "Länder")
    }

    @Test func localizedUnknownLocale() {
        let sut = "Countries".localized(Locale(identifier: "ch"))
        #expect(sut == "Countries")
    }

    @Test func resultIsSuccess() {
        let sut1 = Result<Void, Error>.success(())
        let sut2 = Result<Void, Error>.failure(NSError.test)
        #expect(sut1.isSuccess)
        #expect(!sut2.isSuccess)
    }
}
