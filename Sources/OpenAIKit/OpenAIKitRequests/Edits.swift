//
//  Edits.swift
//
//
//  Created by Kyrylo Mukha on 03.03.2023.
//

import Foundation

@available(swift 5.5)
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public extension OpenAIKit {
	/// Creates a new edit for the provided input, instruction, and parameters.
	///
	/// - Parameters:
	///   - instruction: The instruction that tells the model how to edit the prompt.
	///   - model: ID of the model to use.
	///   - input: The input text to use as a starting point for the edit.
	///   - n: How many completions to generate for each prompt.
	///   - temperature: What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or `topP` but not both.
	///   - topP: An alternative to sampling with `temperature`, called nucleus sampling, where the model considers the results of the tokens with `topP` probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or `temperature` but not both.
	func sendEdits(instruction: String,
	               model: AIModelType,
	               input: String = "",
	               n: Int? = nil,
	               temperature: Double? = 1,
	               topP: Double? = nil,
	               completion: @escaping (Result<AIResponseModel, Error>) -> Void)
	{
		let endpoint = OpenAIEndpoint.edits

		let requestBody = EditsRequest(model: model, input: input, instruction: instruction, n: n, temperature: temperature, topP: topP)

		let requestData = try? jsonEncoder.encode(requestBody)

		let headers = baseHeaders

		network.request(endpoint.method, url: endpoint.urlPath(for: self), body: requestData, headers: headers, completion: completion)
	}

	@available(swift 5.5)
	@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
	func sendEdits(instruction: String,
	               model: AIModelType,
	               input: String = "",
	               n: Int? = nil,
	               temperature: Double? = 1,
	               topP: Double? = nil) async -> Result<AIResponseModel, Error>
	{
		return await withCheckedContinuation { continuation in
			sendEdits(instruction: instruction, model: model, input: input, n: n, temperature: temperature, topP: topP) { result in
				continuation.resume(returning: result)
			}
		}
	}
}
