//
//  AIModel.swift
//
//
//  Created by Kyrylo Mukha on 01.03.2023.
//

import Foundation

public enum AIModelType: RawRepresentable, Codable {
	/// GPT-4 is a large multimodal model that can solve difficult problems with greater accuracy than any of our previous models, thanks to its broader general knowledge and advanced reasoning capabilities. Like `gpt-3.5-turbo`, GPT-4 is optimized for chat but works well for traditional completions tasks.
	case gptV4(GPTv4Model)
	/// GPT-3.5 models can understand and generate natural language or code. Our most capable and cost effective model is gpt-3.5-turbo which is optimized for chat but works well for traditional completions tasks as well.
	case gptV3_5(GPTv3_5Model)
	/// GPT-3 models can understand and generate natural language. These models were superceded by the more powerful GPT-3.5 generation models. However, the original GPT-3 base models (`davinci`, `curie`, `ada`, and `babbage`) are current the only models that are available to fine-tune.
	case gptV3(GPTv3Model)
	/// The Codex models are descendants of our GPT-3 models that can understand and generate code. Their training data contains both natural language and billions of lines of public code from GitHub.
	case codex(CodexModel)
	/// The custom ID of the model to use.
	case custom(String)

	public var rawValue: String {
		switch self {
		case .gptV4(let model):
			return model.rawValue
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
		if let model = GPTv4Model(rawValue: rawValue) {
			self = .gptV4(model)
		} else if let model = GPTv3_5Model(rawValue: rawValue) {
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
	/// GPT-4 is a large multimodal model that can solve difficult problems with greater accuracy than any of our previous models, thanks to its broader general knowledge and advanced reasoning capabilities. Like `gpt-3.5-turbo`, GPT-4 is optimized for chat but works well for traditional completions tasks.
	enum GPTv4Model: String {
		/// More capable than any GPT-3.5 model, able to do more complex tasks, and optimized for chat. Will be updated with our latest model iteration.
		case gpt4 = "gpt-4"
		/// Same capabilities as the base `gpt-4` mode but with 4x the context length. Will be updated with our latest model iteration.
		case gpt4_32k = "gpt-4-32k"
	}

	/// GPT-3.5 models can understand and generate natural language or code. Our most capable and cost effective model is gpt-3.5-turbo which is optimized for chat but works well for traditional completions tasks as well.
	enum GPTv3_5Model: String {
		/// Most capable GPT-3.5 model and optimized for chat at 1/10th the cost of text-davinci-003. Will be updated with our latest model iteration.
		case gptTurbo = "gpt-3.5-turbo"
		/// Can do any language task with better quality, longer output, and consistent instruction-following than the curie, babbage, or ada models. Also supports inserting completions within text.
		case davinciText003 = "text-davinci-003"
		/// Similar capabilities to text-davinci-003 but trained with supervised fine-tuning instead of reinforcement learning
		case davinciText002 = "text-davinci-002"
		/// Optimized for code-completion tasks
		case davinciCode002 = "code-davinci-002"
	}

	/// GPT-3 models can understand and generate natural language. These models were superceded by the more powerful GPT-3.5 generation models. However, the original GPT-3 base models (`davinci`, `curie`, `ada`, and `babbage`) are current the only models that are available to fine-tune.
	enum GPTv3Model: String {
		/// Very capable, faster and lower cost than Davinci.
		case curieText = "text-curie-001"
		/// Capable of straightforward tasks, very fast, and lower cost.
		case babbageText = "text-babbage-001"
		/// Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost.
		case adaText = "text-ada-001"
		/// Most capable GPT-3 model. Can do any task the other models can do, often with higher quality.
		case davinci
		/// Very capable, but faster and lower cost than Davinci.
		case curie
		/// Capable of straightforward tasks, very fast, and lower cost.
		case babbage
		/// Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost.
		case ada
	}

	/// The Codex models are descendants of our GPT-3 models that can understand and generate code. Their training data contains both natural language and billions of lines of public code from GitHub.
	enum CodexModel: String {
		/// Most capable Codex model. Particularly good at translating natural language to code. In addition to completing code, also supports inserting completions within code.
		case davinciCode = "code-davinci-002"
		/// Almost as capable as Davinci Codex, but slightly faster. This speed advantage may make it preferable for real-time applications.
		case cushmanCode = "code-cushman-001"
	}
}

public enum AIMessageRole: String, Codable {
	case system
	case user
	case assistant
}

public struct AIMessage: Codable {
	public let role: AIMessageRole
	public let content: String

	public init(role: AIMessageRole, content: String) {
		self.role = role
		self.content = content
	}
}

public struct AIResponseModel: Codable {
	public struct Choice: Codable {
		public var text: String? = nil
		public var message: AIMessage? = nil
		public let index: Int
		public var logprobs: Int? = nil
		public var finishReason: String? = nil

		private struct AIMessageDelta: Codable {
			var role: AIMessageRole? = nil
			var content: String? = nil
		}

		enum CodingKeys: CodingKey {
			case text
			case message
			case index
			case logprobs
			case finishReason
			case delta
		}

		public init(from decoder: Decoder) throws {
			let container: KeyedDecodingContainer<AIResponseModel.Choice.CodingKeys> = try decoder.container(keyedBy: AIResponseModel.Choice.CodingKeys.self)
			self.text = try container.decodeIfPresent(String.self, forKey: AIResponseModel.Choice.CodingKeys.text)
			self.message = try container.decodeIfPresent(AIMessage.self, forKey: AIResponseModel.Choice.CodingKeys.message)
			self.index = try container.decode(Int.self, forKey: AIResponseModel.Choice.CodingKeys.index)
			self.logprobs = try container.decodeIfPresent(Int.self, forKey: AIResponseModel.Choice.CodingKeys.logprobs)
			self.finishReason = try container.decodeIfPresent(String.self, forKey: AIResponseModel.Choice.CodingKeys.finishReason)

			if let deltaMessage = try? container.decodeIfPresent(AIMessageDelta.self, forKey: AIResponseModel.Choice.CodingKeys.delta) {
				self.message = AIMessage(role: deltaMessage.role ?? .assistant, content: deltaMessage.content ?? "")
			}
		}

		public func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: AIResponseModel.Choice.CodingKeys.self)
			try container.encodeIfPresent(self.text, forKey: AIResponseModel.Choice.CodingKeys.text)
			try container.encodeIfPresent(self.message, forKey: AIResponseModel.Choice.CodingKeys.message)
			try container.encode(self.index, forKey: AIResponseModel.Choice.CodingKeys.index)
			try container.encodeIfPresent(self.logprobs, forKey: AIResponseModel.Choice.CodingKeys.logprobs)
			try container.encodeIfPresent(self.finishReason, forKey: AIResponseModel.Choice.CodingKeys.finishReason)
		}
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
