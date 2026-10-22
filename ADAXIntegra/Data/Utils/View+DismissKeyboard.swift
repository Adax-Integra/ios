//
//  View+DismissKeyboard.swift
//  ADAXIntegra
//

import SwiftUI
import UIKit

/*
 Closes the keyboard when the user taps outside a text field.
 How to use: apply it once on the root view of a page or template.
 MyPage()
   .dismissKeyboardOnTap()
*/

extension View {
  // closes the keyboard when tapping outside the fields
  func dismissKeyboardOnTap() -> some View {
    background(KeyboardDismissTapInstaller())
  }
}

// adds a uikit tap recognizer to the screen that does not cancel the taps of buttons, links, menus or rows
private struct KeyboardDismissTapInstaller: UIViewRepresentable {
  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  func makeUIView(context: Context) -> InstallerView {
    let view = InstallerView()
    view.coordinator = context.coordinator
    view.isUserInteractionEnabled = false
    return view
  }

  func updateUIView(_ uiView: InstallerView, context: Context) {}

  static func dismantleUIView(_ uiView: InstallerView, coordinator: Coordinator) {
    coordinator.detach()
  }

  final class InstallerView: UIView {
    weak var coordinator: Coordinator?

    // attaches the recognizer to the view of the screen that contains this page
    override func didMoveToWindow() {
      super.didMoveToWindow()
      guard window != nil, let screenView = nearestControllerView() else { return }
      coordinator?.attach(to: screenView)
    }

    private func nearestControllerView() -> UIView? {
      var responder: UIResponder? = self
      while let current = responder {
        if let controller = current as? UIViewController {
          return controller.view
        }
        responder = current.next
      }
      return nil
    }
  }

  final class Coordinator: NSObject, UIGestureRecognizerDelegate {
    private lazy var recognizer: UITapGestureRecognizer = {
      let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
      recognizer.cancelsTouchesInView = false
      recognizer.delaysTouchesEnded = false
      recognizer.delegate = self
      return recognizer
    }()

    func attach(to view: UIView) {
      guard recognizer.view !== view else { return }
      detach()
      view.addGestureRecognizer(recognizer)
    }

    func detach() {
      recognizer.view?.removeGestureRecognizer(recognizer)
    }

    @objc private func handleTap() {
      UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
      )
    }

    // ignores taps on a text field so the keyboard does not close while opening it
    func gestureRecognizer(
      _ gestureRecognizer: UIGestureRecognizer,
      shouldReceive touch: UITouch
    ) -> Bool {
      var view = touch.view
      while let current = view {
        if current is UITextField || current is UITextView {
          return false
        }
        view = current.superview
      }
      return true
    }

    // lets the taps of the children work at the same time
    func gestureRecognizer(
      _ gestureRecognizer: UIGestureRecognizer,
      shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
      true
    }
  }
}
