@testable import OpenAIKit
import XCTest

final class OpenAIKitTests: XCTestCase {
	var openAI: OpenAIKit?

	override func setUp() {
		super.setUp()

		openAI = OpenAIKit(apiToken: "<Your OpenAI API Token here>")
	}

	func testCompletions() async {
		let result = await openAI?.sendCompletion(prompt: "Write a 100-word essay about the earth", model: .gptV3_5(.davinciText003), maxTokens: 300, temperature: 0.7)

		switch result {
		case .success(let aiResult):
			XCTAssertFalse(aiResult.choices.isEmpty)
		case .failure(let error):
			print(error.localizedDescription)
			XCTAssertFalse(true)
		default:
			XCTAssertFalse(true)
		}
	}

	func testEdits() async {
		let result = await openAI?.sendEdits(instruction: "Fix the spelling mistakes", model: .custom("text-davinci-edit-001"), input: "What day of the wek is it?")

		switch result {
		case .success(let aiResult):
			XCTAssertFalse(aiResult.choices.isEmpty)
		case .failure(let error):
			print(error.localizedDescription)
			XCTAssertFalse(true)
		default:
			XCTAssertFalse(true)
		}
	}

	func testImages() async {
		let result = await openAI?.sendImagesRequest(prompt: "Draw orange butterfly", size: .size256, n: 1)

		switch result {
		case .success(let aiResult):
			XCTAssertFalse(aiResult.data.isEmpty)
		case .failure(let error):
			print(error.localizedDescription)
			XCTAssertFalse(true)
		default:
			XCTAssertFalse(true)
		}
	}

	func testStreamCompletions() {
		let expectation = XCTestExpectation(description: "Async operation completes")

		var resultText = ""

		openAI?.sendStreamCompletion(prompt: "Write a 100-word essay about the earth", model: .gptV3_5(.davinciText003), maxTokens: 300, completion: { result in
			switch result {
			case .success(let streamResult):
				resultText += streamResult.message?.choices.first?.text ?? ""

				if streamResult.isFinished {
					expectation.fulfill()
				}
			case .failure(let error):
				print(error.localizedDescription)
				expectation.fulfill()
			}
		})

		wait(for: [expectation], timeout: 300)
		XCTAssertFalse(resultText.isEmpty)
	}

	func testStreamChatCompletions() {
		let expectation = XCTestExpectation(description: "Async operation completes")

		var resultText = ""

		openAI?.sendStreamChatCompletion(newMessage: AIMessage(role: .user, content: "Write a 100-word essay about the earth"), model: .gptV3_5(.gptTurbo), maxTokens: 300, temperature: 0.7) { result in

			switch result {
			case .success(let streamResult):
				resultText += streamResult.message?.choices.first?.message?.content ?? ""

				if streamResult.isFinished {
					expectation.fulfill()
				}
			case .failure(let error):
				print(error.localizedDescription)
				expectation.fulfill()
			}
		}

		wait(for: [expectation], timeout: 300)
		XCTAssertFalse(resultText.isEmpty)
	}

	func testChatResponseFormatCompletions() {
		let expectation = XCTestExpectation(description: "Async operation completes")

		var resultText = ""

		openAI?.sendChatCompletion(newMessage: AIMessage(role: .user, content: "Write a 100-word essay about the earth"), previousMessages: [AIMessage(role: .system, content: "You are a helpful assistant designed to output JSON.")], model: .custom("gpt-3.5-turbo-1106"), maxTokens: 300, temperature: 0.7, responseFormat: .json) { result in

			switch result {
			case .success(let streamResult):
				resultText += streamResult.choices.first?.message?.content ?? ""

				expectation.fulfill()
			case .failure(let error):
				print(error.localizedDescription)
				expectation.fulfill()
			}
		}

		wait(for: [expectation], timeout: 300)
		XCTAssertFalse(resultText.isEmpty)
	}
}
