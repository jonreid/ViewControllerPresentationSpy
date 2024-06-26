// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SwiftSampleViewControllerPresentationSpy
import ViewControllerPresentationSpy
import XCTest

final class ViewControllerPresentationTests: XCTestCase {
    private var presentationVerifier: PresentationVerifier!
    private var sut: ViewController!

    @MainActor
    override func setUp() {
        super.setUp()
        presentationVerifier = PresentationVerifier()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        RunLoop.current.run(until: Date()) // Free objects after segue show
        presentationVerifier = nil
        sut = nil
        super.tearDown()
    }

    @MainActor
    func test_outlets_shouldBeConnected() {
        XCTAssertNotNil(sut.seguePresentModalButton)
        XCTAssertNotNil(sut.segueShowButton)
        XCTAssertNotNil(sut.codePresentModalButton)
    }

    @MainActor
    func test_tappingSeguePresentModalButton_shouldPresentNextViewControllerWithGreenBackground() {
        sut.seguePresentModalButton.sendActions(for: .touchUpInside)

        let nextVC: StoryboardNextViewController? =
                presentationVerifier.verify(animated: true, presentingViewController: sut)
        XCTAssertEqual(nextVC?.backgroundColor, .green, "Background color passed in")
    }

    @MainActor
    func test_tappingSegueShowButton_shouldShowNextViewControllerWithRedBackground() {
        let window = UIWindow()
        window.rootViewController = sut
        window.isHidden = false

        sut.segueShowButton.sendActions(for: .touchUpInside)

        let nextVC: StoryboardNextViewController? =
                presentationVerifier.verify(animated: true, presentingViewController: sut)
        XCTAssertEqual(nextVC?.backgroundColor, .red, "Background color passed in")
    }

    @MainActor
    func test_tappingCodeModalButton_shouldPresentNextViewControllerWithPurpleBackground() {
        sut.codePresentModalButton.sendActions(for: .touchUpInside)

        let nextVC: CodeNextViewController? =
                presentationVerifier.verify(animated: true, presentingViewController: sut)
        XCTAssertEqual(nextVC?.backgroundColor, .purple, "Background color passed in")
    }
}
