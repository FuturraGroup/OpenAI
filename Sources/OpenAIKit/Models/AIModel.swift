//
//  AIModel.swift
//
//
//  Created by Kyrylo Mukha on 01.03.2023.
//

import Foundation

public enum AIModelType: RawRepresentable, Codable {
	case gptV3_5(GPTv3_5Model)

	case gptV3(GPTv3Model)

	case codex(CodexModel)

	case custom(String)

	public var rawValue: String {
		switch self {
		case .gptV3_5(let model):
			return model.rawValue
		case .gptV3(let model):
			return model.rawValue
		case .codex(let model):
			return model.rawValue
		case .custom(let model):
			return model
		}
	}

	public init?(rawValue: RawValue) {
		if let model = GPTv3_5Model(rawValue: rawValue) {
			self = .gptV3_5(model)
		} else if let model = GPTv3Model(rawValue: rawValue) {
			self = .gptV3(model)
		} else if let model = CodexModel(rawValue: rawValue) {
			self = .codex(model)
		} else {
			self = .custom(rawValue)
		}
	}
}

public extension AIModelType {
	enum GPTv3_5Model: String {
		case gptTurbo = "gpt-3.5-turbo"

		case davinciText003 = "text-davinci-003"

		case davinciText002 = "text-davinci-002"

		case davinciCode002 = "code-davinci-002"
	}

	enum GPTv3Model: String {
		case curieText = "text-curie-001"

		case babbageText = "text-babbage-001"

		case adaText = "text-ada-001"

		case davinci

		case curie

		case babbage

		case ada
	}

	enum CodexModel: String {
		case davinciCode = "code-davinci-002"

		case cushmanCode = "code-cushman-001"
	}
}

public struct AIResponseModel: Codable {
	public struct Choice: Codable {
		public let text: String
		public let index: Int
		public var logprobs: Int? = nil
		public var finishReason: String? = nil
	}

	public struct Usage: Codable {
		public var promptTokens: Int? = nil
		public var completionTokens: Int? = nil
		public var totalTokens: Int? = nil
	}

	public struct Logprobs: Codable {
		public var tokens: [String]? = nil
		public var tokenLogprobs: [Double]? = nil
		public var topLogprobs: [String: Double]? = nil
		public var textOffset: [Int]? = nil
	}

	public var id: String? = nil
	public let object: String
	public let created: TimeInterval
	public var model: AIModelType? = nil
	public let choices: [Choice]
	public var usage: Usage? = nil
	public var logprobs: Logprobs? = nil
}
