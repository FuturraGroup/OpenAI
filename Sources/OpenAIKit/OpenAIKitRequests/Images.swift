//
//  Images.swift
//
//
//  Created by Kyrylo Mukha on 03.03.2023.
//

import Foundation

public extension OpenAIKit {
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
