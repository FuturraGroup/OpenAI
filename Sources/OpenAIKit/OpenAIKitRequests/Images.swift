//
//  Images.swift
//
//
//  Created by Kyrylo Mukha on 03.03.2023.
//

import Foundation

@available(swift 5.5)
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public extension OpenAIKit {
	/// Given a prompt and/or an input image, the model will generate a new image.
	///
	/// - Parameters:
	///   - prompt: The prompt to generate completions for, encoded as a string, array of strings, array of tokens, or array of token arrays.
	///   - size: The size of the generated images. Must be one of `size256`, `size512`, or `size1024`.
	///   - user: A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
	///   - n: How many completions to generate for each prompt.
	func sendImagesRequest(prompt: String,
	                       size: AIImageSize = .size1024,
	                       user: String? = nil,
	                       n: Int? = nil,
	                       completion: @escaping (Result<ImagesResponse, Error>) -> Void)
	{
		let endpoint = OpenAIEndpoint.dalleImage

		let requestBody = ImageRequest(prompt: prompt, n: n, size: size, user: user)

		let requestData = try? jsonEncoder.encode(requestBody)

		let headers = baseHeaders

		network.request(endpoint.method, url: endpoint.urlPath, body: requestData, headers: headers, completion: completion)
	}

	@available(swift 5.5)
	@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
	func sendImagesRequest(prompt: String,
	                       size: AIImageSize = .size1024,
	                       user: String? = nil,
	                       n: Int? = nil) async -> Result<ImagesResponse, Error>
	{
		return await withCheckedContinuation { continuation in
			sendImagesRequest(prompt: prompt, size: size, user: user, n: n) { result in
				continuation.resume(returning: result)
			}
		}
	}
}
