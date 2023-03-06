//
//  ViewController.swift
//  OpenAIKit
//
//  Created by Kyrylo Mukha on 03/06/2023.
//  Copyright (c) 2023 Kyrylo Mukha. All rights reserved.
//

import Foundation
import OpenAIKit
import UIKit

class ViewController: UIViewController {
	@IBOutlet private weak var textField: UITextField!
	@IBOutlet private weak var textView: UITextView!
	@IBOutlet private weak var loader: UIActivityIndicatorView!
	@IBOutlet private weak var sendBtn: UIButton!
	@IBOutlet private weak var bottomOffset: NSLayoutConstraint!
	
	// MARK: -
	
	private var observers = [NSObjectProtocol]()
	
	// MARK: -
	
	deinit {
		observers.forEach { NotificationCenter.default.removeObserver($0) }
		observers.removeAll()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
		configureOBservers()
		stopLoading()
		
		textField.becomeFirstResponder()
	}
}

extension ViewController {
	@IBAction private func sendQuestion() {
		startLoading()
		textView.text = " "
		
		let prompt = textField.text ?? ""
		
		openAI.sendCompletion(prompt: prompt, model: .gptV3_5(.davinciText003), maxTokens: 2048) { [weak self] result in
			DispatchQueue.main.async { self?.stopLoading() }
			
			switch result {
			case .success(let aiResult):
				DispatchQueue.main.async { [weak self] in
					if let text = aiResult.choices.first?.text {
						self?.textView.text = text
					}
				}
			case .failure(let error):
				DispatchQueue.main.async { [weak self] in
					let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "Ok", style: .default))
					self?.present(alert, animated: true)
				}
			}
		}
	}
}

extension ViewController {
	private func configureOBservers() {
		observers.append(NotificationCenter.default.addObserver(
			forName: UIResponder.keyboardWillShowNotification,
			object: nil,
			queue: OperationQueue.main,
			using: { [weak self] notification in
				DispatchQueue.main.async { [weak self] in
					guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
					self?.bottomOffset.constant = keyboardHeight + 16
					self?.sendBtn.isHidden = false
					self?.view.layoutSubviews()
				}
			}))

		observers.append(NotificationCenter.default.addObserver(
			forName: UIResponder.keyboardWillHideNotification,
			object: nil,
			queue: OperationQueue.main,
			using: { [weak self] _ in
				DispatchQueue.main.async { [weak self] in
					UIView.animate(withDuration: 0.275) { [weak self] in
						self?.bottomOffset.constant = 16
						self?.sendBtn.isHidden = true
						self?.view.layoutSubviews()
					}
				}
			}))
	}
	
	private func startLoading() {
		view.isUserInteractionEnabled = false
		loader.startAnimating()
		loader.isHidden = false
	}

	private func stopLoading() {
		textField.resignFirstResponder()
		view.isUserInteractionEnabled = true
		loader.stopAnimating()
		loader.isHidden = true
	}
}
