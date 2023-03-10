//
//  Chat.swift
//
//
//  Created by Kyrylo Mukha on 10.03.2023.
//

import Foundation

public extension OpenAIKit {
	func sendChatCompletion(newMessage: AIResponseModel.AIMessage,
	                        previousMessages: [AIResponseModel.AIMessage] = [],
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
	                        completion: @escaping (Result<AIResponseModel, Error>) -> Void)
	{
		let endpoint = OpenAIEndpoint.completions

		var messages = previousMessages
		messages.append(newMessage)

		let requestBody = ChatCompletionsModels(model: model, messages: messages, temperature: temperature, n: n, maxTokens: maxTokens, topP: topP, frequencyPenalty: frequencyPenalty, presencePenalty: presencePenalty, logprobs: logprobs, stop: stop, user: user)

		let requestData = try? jsonEncoder.encode(requestBody)

		let headers = baseHeaders

		network.request(endpoint.method, url: endpoint.urlPath, body: requestData, headers: headers, completion: completion)
	}

	@available(swift 5.5)
	@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
	func sendChatCompletion(newMessage: AIResponseModel.AIMessage,
	                        previousMessages: [AIResponseModel.AIMessage] = [],
	                        model: AIModelType,
	                        maxTokens: Int?,
	                        temperature: Double = 1,
	                        n: Int? = nil,
	                        topP: Double? = nil,
	                        frequencyPenalty: Double? = nil,
	                        presencePenalty: Double? = nil,
	                        logprobs: Int? = nil,
	                        stop: [String]? = nil,
	                        user: String? = nil) async -> Result<AIResponseModel, Error>
	{
		return await withCheckedContinuation { continuation in
			sendChatCompletion(newMessage: newMessage, previousMessages: previousMessages, model: model, maxTokens: maxTokens, temperature: temperature, n: n, topP: topP, frequencyPenalty: frequencyPenalty, presencePenalty: presencePenalty, logprobs: logprobs, stop: stop, user: user) { result in
				continuation.resume(returning: result)
			}
		}
	}
}
