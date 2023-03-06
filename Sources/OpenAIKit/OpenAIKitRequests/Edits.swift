//
//  Edits.swift
//
//
//  Created by Kyrylo Mukha on 03.03.2023.
//

import Foundation

public extension OpenAIKit {
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

		network.request(endpoint.method, url: endpoint.urlPath, body: requestData, headers: headers, completion: completion)
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
