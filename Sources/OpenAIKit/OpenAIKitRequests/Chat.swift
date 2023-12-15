//
//  Chat.swift
//
//
//  Created by Kyrylo Mukha on 10.03.2023.
//

import Combine
import Foundation

@available(swift 5.5)
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public extension OpenAIKit {
	/// Creates a completion for the chat message
	///
	/// - Parameters:
	///   - newMessage: The main input is the `newMessage` parameter. Where each object has a `role` (either `system`, `user`, or `assistant`) and `content` (the content of the message).
	///   - previousMessages: Previous messages, an optional parameter, the assistant will communicate in the context of these messages. Must be an array of `AIMessage` objects.
	///   - model: ID of the model to use.
	///   - maxTokens: The maximum number of tokens to generate in the completion.
	///   - temperature: What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or `topP` but not both.
	///   - n: How many completions to generate for each prompt.
	///   - topP: An alternative to sampling with `temperature`, called nucleus sampling, where the model considers the results of the tokens with `topP` probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or `temperature` but not both.
	///   - frequencyPenalty: Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
	///   - presencePenalty: Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
	///   - logprobs: Include the log probabilities on the `logprobs` most likely tokens, as well the chosen tokens. For example, if `logprobs` is 5, the API will return a list of the 5 most likely tokens. The API will always return the `logprob` of the sampled token, so there may be up to `logprobs+1` elements in the response. The maximum value for `logprobs` is 5.
	///   - stop: Up to 4 sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence.
	///   - user: A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
	func sendChatCompletion(
		newMessage: AIMessage,
		previousMessages: [AIMessage] = [],
		model: AIModelType,
		maxTokens: Int?,
		temperature: Double = 1,
		n: Int? = nil,
		topP: Double? = nil,
		frequencyPenalty: Double? = nil,
		presencePenalty: Double? = nil,
		logprobs: Int? = nil,
		stop: [String]? = nil,
		responseFormat: ChatCompletionsRequest.ResponseFormat? = nil,
		user: String? = nil,
		completion: @escaping (Result<AIResponseModel, Error>) -> Void
	) {
		let endpoint = OpenAIEndpoint.chatCompletions

		var messages = previousMessages
		messages.append(newMessage)

		let requestBody = ChatCompletionsRequest(model: model, messages: messages, temperature: temperature, n: n, maxTokens: maxTokens, topP: topP, frequencyPenalty: frequencyPenalty, presencePenalty: presencePenalty, logprobs: logprobs, responseFormat: responseFormat, stop: stop, user: user)

		let requestData = try? jsonEncoder.encode(requestBody)

		let headers = baseHeaders

		network.request(endpoint.method, url: endpoint.urlPath(for: self), body: requestData, headers: headers, completion: completion)
	}

	@available(swift 5.5)
	@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
	func sendChatCompletion(
		newMessage: AIMessage,
		previousMessages: [AIMessage] = [],
		model: AIModelType,
		maxTokens: Int?,
		temperature: Double = 1,
		n: Int? = nil,
		topP: Double? = nil,
		frequencyPenalty: Double? = nil,
		presencePenalty: Double? = nil,
		logprobs: Int? = nil,
		stop: [String]? = nil,
		responseFormat: ChatCompletionsRequest.ResponseFormat? = nil,
		user: String? = nil
	) async -> Result<AIResponseModel, Error> {
		return await withCheckedContinuation { continuation in
			sendChatCompletion(
				newMessage: newMessage,
				previousMessages: previousMessages,
				model: model,
				maxTokens: maxTokens,
				temperature: temperature,
				n: n,
				topP: topP,
				frequencyPenalty: frequencyPenalty,
				presencePenalty: presencePenalty,
				logprobs: logprobs,
				stop: stop,
				responseFormat: responseFormat,
				user: user
			) { result in
				continuation.resume(returning: result)
			}
		}
	}
}

// MARK: - Stream methods

@available(swift 5.5)
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public extension OpenAIKit {
	/// Creates a completion for the chat message
	///
	/// - Parameters:
	///   - newMessage: The main input is the `newMessage` parameter. Where each object has a `role` (either `system`, `user`, or `assistant`) and `content` (the content of the message).
	///   - previousMessages: Previous messages, an optional parameter, the assistant will communicate in the context of these messages. Must be an array of `AIMessage` objects.
	///   - model: ID of the model to use.
	///   - maxTokens: The maximum number of tokens to generate in the completion.
	///   - temperature: What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or `topP` but not both.
	///   - n: How many completions to generate for each prompt.
	///   - topP: An alternative to sampling with `temperature`, called nucleus sampling, where the model considers the results of the tokens with `topP` probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or `temperature` but not both.
	///   - frequencyPenalty: Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
	///   - presencePenalty: Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
	///   - logprobs: Include the log probabilities on the `logprobs` most likely tokens, as well the chosen tokens. For example, if `logprobs` is 5, the API will return a list of the 5 most likely tokens. The API will always return the `logprob` of the sampled token, so there may be up to `logprobs+1` elements in the response. The maximum value for `logprobs` is 5.
	///   - stop: Up to 4 sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence.
	///   - user: A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
	func sendStreamChatCompletion(
		newMessage: AIMessage,
		previousMessages: [AIMessage] = [],
		model: AIModelType,
		maxTokens: Int?,
		temperature: Double = 1,
		n: Int? = nil,
		topP: Double? = nil,
		frequencyPenalty: Double? = nil,
		presencePenalty: Double? = nil,
		logprobs: Int? = nil,
		stop: [String]? = nil,
		user: String? = nil,
		completion: @escaping (Result<AIStreamResponse<AIResponseModel>, Error>) -> Void
	) {
		let endpoint = OpenAIEndpoint.chatCompletions

		var messages = previousMessages
		messages.append(newMessage)

		let requestBody = ChatCompletionsRequest(model: model, messages: messages, temperature: temperature, n: n, maxTokens: maxTokens, topP: topP, frequencyPenalty: frequencyPenalty, presencePenalty: presencePenalty, logprobs: logprobs, stop: stop, user: user, stream: true)

		let requestData = try? jsonEncoder.encode(requestBody)

		let headers = baseHeaders

		network.requestStream(endpoint.method, url: endpoint.urlPath(for: self), body: requestData, headers: headers) { (result: Result<AIStreamResponse<AIResponseModel>, Error>) in
			completion(result)
		}
	}

	@available(swift 5.5)
	@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
	func sendStreamChatCompletion(
		newMessage: AIMessage,
		previousMessages: [AIMessage] = [],
		model: AIModelType,
		maxTokens: Int?,
		temperature: Double = 1,
		n: Int? = nil,
		topP: Double? = nil,
		frequencyPenalty: Double? = nil,
		presencePenalty: Double? = nil,
		logprobs: Int? = nil,
		stop: [String]? = nil,
		user: String? = nil
	) async throws -> AsyncThrowingStream<AIStreamResponse<AIResponseModel>, Error> {
		let endpoint = OpenAIEndpoint.chatCompletions

		var messages = previousMessages
		messages.append(newMessage)

		let requestBody = ChatCompletionsRequest(model: model, messages: messages, temperature: temperature, n: n, maxTokens: maxTokens, topP: topP, frequencyPenalty: frequencyPenalty, presencePenalty: presencePenalty, logprobs: logprobs, stop: stop, user: user, stream: true)

		let requestData = try? jsonEncoder.encode(requestBody)

		let headers = baseHeaders

		return try await network.requestStream(endpoint.method, url: endpoint.urlPath(for: self), body: requestData, headers: headers)
	}
}
