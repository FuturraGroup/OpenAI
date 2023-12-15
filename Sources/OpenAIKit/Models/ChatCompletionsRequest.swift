//
//  ChatCompletionsModels.swift
//
//
//  Created by Kyrylo Mukha on 10.03.2023.
//

import Foundation

public struct ChatCompletionsRequest: Codable {
	/// ID of the model to use.
	public let model: AIModelType
	/// The messages to generate chat completions for. Must be an array of `AIMessage` objects.
	public let messages: [AIMessage]
	/// What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.
	public var temperature: Double? = nil
	/// How many chat completion choices to generate for each input message.
	public var n: Int? = nil
	/// The maximum number of tokens allowed for the generated answer. By default, the number of tokens the model can return will be (4096 - prompt tokens).
	public var maxTokens: Int? = nil
	/// An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with `topP` probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.
	public var topP: Double? = nil
	/// Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
	public var frequencyPenalty: Double? = nil
	/// Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
	public var presencePenalty: Double? = nil
	/// Include the log probabilities on the `logprobs` most likely tokens, as well the chosen tokens. For example, if `logprobs` is 5, the API will return a list of the 5 most likely tokens. The API will always return the `logprob` of the sampled token, so there may be up to `logprobs+1` elements in the response. The maximum value for `logprobs` is 5.
	public var logprobs: Int? = nil
	/// An object specifying the format that the model must output.
	/// Setting to `{ "type": "json_object" }` enables JSON mode, which guarantees the message the model generates
	/// is valid JSON.
	/// **Important:** when using JSON mode, you must also instruct the model to produce JSON yourself via a system or
	/// user message. Without this, the model may generate an unending stream of whitespace until the generation reaches
	/// the token limit, resulting in a long-running and seemingly "stuck" request. Also note that the message content
	/// may be partially cut off if finish_reason="length", which indicates the generation exceeded max_tokens or the
	/// conversation exceeded the max context length.
	public var responseFormat: ResponseFormat?
	/// Up to 4 sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence.
	public var stop: [String]? = nil
	/// A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
	public var user: String? = nil
	/// Whether to stream back partial progress. If set, tokens will be sent as data-only server-sent events as they become available
	public var stream: Bool = false
	public struct ResponseFormat: Codable {
		internal var type: FormatType?
		internal enum FormatType: String, Codable {
			case text, jsonObject = "json_object"
		}

		public static let json = ResponseFormat(type: .jsonObject)
		public static let text = ResponseFormat(type: .text)
	}
}
