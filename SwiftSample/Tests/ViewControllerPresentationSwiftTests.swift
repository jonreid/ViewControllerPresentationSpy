// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2015 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SwiftSampleViewControllerPresentationSpy
import ViewControllerPresentationSpy
import Testing
import UIKit

@MainActor
final class ViewControllerPresentationSwiftTests: @unchecked Sendable {
    private let sut: ViewController

    init() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
    }

    @Test("outlets are connected")
    func outlets_areConnected() throws {
        #expect(sut.seguePresentModalButton != nil)
        #expect(sut.segueShowButton != nil)
        #expect(sut.codePresentModalButton != nil)
    }

    @Test("tapping segue present modal button presents next view with green background")
    func tappingSeguePresentModalButton_presentsNextViewWithGreenBackground() throws {
        let presentationVerifier = PresentationVerifier()

        sut.seguePresentModalButton.sendActions(for: .touchUpInside)

        let nextVC: StoryboardNextViewController? =
            presentationVerifier.verify(animated: true, presentingViewController: sut)
        #expect(nextVC?.backgroundColor == .green, "Background color passed in")
    }

    @Test("tapping segue show button shows next view with red background")
    func tappingSegueShowButton_showsNextViewWithRedBackground() throws {
        let presentationVerifier = PresentationVerifier()
        let window = UIWindow()
        window.rootViewController = sut
        window.isHidden = false

        sut.segueShowButton.sendActions(for: .touchUpInside)

        let nextVC: StoryboardNextViewController? =
            presentationVerifier.verify(animated: true, presentingViewController: sut)
        #expect(nextVC?.backgroundColor == .red, "Background color passed in")
    }

    @Test("tapping code modal button presents next view with purple background")
    func tappingCodeModalButton_presentsNextViewWithPurpleBackground() throws {
        let presentationVerifier = PresentationVerifier()

        sut.codePresentModalButton.sendActions(for: .touchUpInside)

        let nextVC: CodeNextViewController? =
            presentationVerifier.verify(animated: true, presentingViewController: sut)
        #expect(nextVC?.backgroundColor == .purple, "Background color passed in")
    }
} 
