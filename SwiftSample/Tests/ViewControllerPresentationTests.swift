// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SwiftSampleViewControllerPresentationSpy
import ViewControllerPresentationSpy
import XCTest

@MainActor
final class ViewControllerPresentationTests: XCTestCase, Sendable {
    private var presentationVerifier: PresentationVerifier!
    private var sut: ViewController!

    override func setUp() async throws {
        try await super.setUp()
        presentationVerifier = PresentationVerifier()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
    }

    override func tearDown() async throws {
        RunLoop.current.run(until: Date()) // Free objects after segue show
        presentationVerifier = nil
        sut = nil
        try await super.tearDown()
    }

    func test_outlets_shouldBeConnected() {
        XCTAssertNotNil(sut.seguePresentModalButton)
        XCTAssertNotNil(sut.segueShowButton)
        XCTAssertNotNil(sut.codePresentModalButton)
    }

    func test_tappingSeguePresentModalButton_shouldPresentNextViewControllerWithGreenBackground() {
        sut.seguePresentModalButton.sendActions(for: .touchUpInside)

        let nextVC: StoryboardNextViewController? =
            presentationVerifier.verify(animated: true, presentingViewController: sut)
        XCTAssertEqual(nextVC?.backgroundColor, .green, "Background color passed in")
    }

    func test_tappingSegueShowButton_shouldShowNextViewControllerWithRedBackground() {
        let window = UIWindow()
        window.rootViewController = sut
        window.isHidden = false

        sut.segueShowButton.sendActions(for: .touchUpInside)

        let nextVC: StoryboardNextViewController? =
            presentationVerifier.verify(animated: true, presentingViewController: sut)
        XCTAssertEqual(nextVC?.backgroundColor, .red, "Background color passed in")
    }

    func test_tappingCodeModalButton_shouldPresentNextViewControllerWithPurpleBackground() {
        sut.codePresentModalButton.sendActions(for: .touchUpInside)

        let nextVC: CodeNextViewController? =
            presentationVerifier.verify(animated: true, presentingViewController: sut)
        XCTAssertEqual(nextVC?.backgroundColor, .purple, "Background color passed in")
    }
}
