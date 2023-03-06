//
//  Completions.swift
//
//
//  Created by Kyrylo Mukha on 03.03.2023.
//

import Foundation

public extension OpenAIKit {
	func sendCompletion(prompt: String,
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

		let requestBody = CompletionsRequest(model: model, prompt: prompt, temperature: temperature, n: n, maxTokens: maxTokens, topP: topP, frequencyPenalty: frequencyPenalty, presencePenalty: presencePenalty, logprobs: logprobs, stop: stop, user: user)

		let requestData = try? jsonEncoder.encode(requestBody)

		let headers = baseHeaders

		network.request(endpoint.method, url: endpoint.urlPath, body: requestData, headers: headers, completion: completion)
	}

	@available(swift 5.5)
	@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
	func sendCompletion(prompt: String,
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
			sendCompletion(prompt: prompt, model: model, maxTokens: maxTokens, temperature: temperature, n: n, topP: topP, frequencyPenalty: frequencyPenalty, presencePenalty: presencePenalty, logprobs: logprobs, stop: stop, user: user) { result in
				continuation.resume(returning: result)
			}
		}
	}
}
