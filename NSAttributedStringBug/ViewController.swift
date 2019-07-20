//
//  ViewController.swift
//  NSAttributedStringBug
//
//  Created by Roman Baev on 20/07/2019.
//  Copyright © 2019 Roman Baev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  let scrollView = UIScrollView()
  let stackView = UIStackView()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()

    let strings: [NSAttributedString] = [
      .create(string: "Line spacing only", lineSpacing: 20),
      .create(string: "Line spacing only + multiline", lineSpacing: 20),

      .create(string: "Kern only", kern: 2),
      .create(string: "Kern only + multiline multiline", kern: 2),

      .create(string: "Line spacing + kern", lineSpacing: 20, kern: 2),
      .create(string: "Line spacing + kern + multiline", lineSpacing: 20, kern: 2),

      .create(string: "Write direction only", writingDirection: .rightToLeft),
      .create(string: "Wd + ls", lineSpacing: 20, writingDirection: .rightToLeft),
      .create(string: "Write direction + line spacing + multiline", lineSpacing: 20, writingDirection: .rightToLeft)
    ]

    for string in strings {
      let label = UILabel()
      label.numberOfLines = 0
      label.backgroundColor = .red
      label.attributedText = string
      stackView.addArrangedSubview(label)
    }
  }

  private func setupUI() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.contentInsetAdjustmentBehavior = .always

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 20

    view.addSubview(scrollView)
    scrollView.addSubview(stackView)

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
      stackView.widthAnchor.constraint(equalToConstant: 200),
      stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20)
    ])
  }
}

extension NSAttributedString {
  static func create(string: String,
                     lineSpacing: CGFloat? = nil,
                     kern: CGFloat? = nil,
                     writingDirection: NSWritingDirection? = nil) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: string)
    let range = NSMakeRange(0, attributedString.length)

    if let lineSpacing = lineSpacing {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = lineSpacing
      attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
    }

    if let kern = kern {
      attributedString.addAttribute(.kern, value: kern, range: range)
    }

    if let writingDirection = writingDirection {
      attributedString.addAttribute(.writingDirection, value: [writingDirection.rawValue], range: range)
    }

    return attributedString
  }
}

