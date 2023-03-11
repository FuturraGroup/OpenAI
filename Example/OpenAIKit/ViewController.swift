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
		/// You can put messages you send and recieved before for maka chat uderstand your context.
		/// Be careful! There is limit of total tokens count. The total limit of tokens is 4096.
		/// So if you requests maxTokens = 2048, total sum of tokens in newMessage + previousMessages must be 2048.
		/// Number of tokens you can recieve from response model from field usage.
		let previousMessages: [AIMessage] = []
		
		openAI?.sendChatCompletion(newMessage: AIMessage(role: .user, content: prompt), previousMessages: previousMessages, model: .gptV3_5(.gptTurbo), maxTokens: 2048, n: 1, completion: { [weak self] result in in
			DispatchQueue.main.async { self?.stopLoading() }
			
			switch result {
			case .success(let aiResult):
				DispatchQueue.main.async { [weak self] in
					if let text = aiResult.choices.first?.message?.content {
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
		})
		
		openAI.sendCompletion(prompt: prompt, model: .gptV3_5(.davinciText003), maxTokens: 2048) { [weak self] _ in
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
