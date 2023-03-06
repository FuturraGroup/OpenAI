@testable import OpenAIKit
import XCTest

final class OpenAIKitTests: XCTestCase {
	var openAI: OpenAIKit?

	override func setUp() {
		super.setUp()
	
		self.openAI = OpenAIKit(apiToken: "<Your OpenAI API Token here>")
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
}
