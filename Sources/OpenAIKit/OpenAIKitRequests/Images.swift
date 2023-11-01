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
    // MARK: - Create image
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

		network.request(endpoint.method, url: endpoint.urlPath(for: self), body: requestData, headers: headers, completion: completion)
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
    
    // MARK: - Create image edit
    /// Given a prompt and an input image, the model will genreate generate a modified version of the input image
    ///
    /// - Parameters:
    ///  - image: The image to edit. Must be a valid PNG file, less than 4MB, and square. If mask is not provided, image must have transparency, which will be used as the mask.
    ///  - prompt: A text description of the desired image(s). The maximum length is 1000 characters.
    ///  - size: The size of the generated images. Must be one of `size256`, `size512`, or `size1024`.
    ///  - responseFormat: The format in which the generated images are returned. Must be one of url or b64_json.
    ///  - mask: An additional image whose fully transparent areas (e.g. where alpha is zero) indicate where image should be edited. Must be a valid PNG file, less than 4MB, and have the same dimensions as image.
    ///  - user: A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
    ///  - n : How many completions to generate for each prompt.
    func sendImageEditRequest(image: String,
                           prompt: String,
                           size: AIImageSize = .size1024,
                           responseFormat: String? = nil,
                           mask: String? = nil,
                           user: String? = nil,
                           n: Int? = nil,
                           completion: @escaping (Result<ImagesResponse, Error>) -> Void)
    {
        let endpoint = OpenAIEndpoint.dalleImageEdit
        
        let requestBody = ImageEditRequest(image: image, mask: mask, prompt: prompt, n: n, size: size, responseFormat: responseFormat, user: user)
        
        let requestData = try? jsonEncoder.encode(requestBody)
        
        let headers = baseMultipartHeaders
        
        network.request(endpoint.method, url: endpoint.urlPath(for: self), body: requestData, headers: headers, completion: completion)
    }
    
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    func sendImageEditRequest(image: String,
                              prompt: String,
                              size: AIImageSize = .size1024,
                              responseFormat: String? = nil,
                              mask: String? = nil,
                              user: String? = nil,
                              n: Int? = nil) async -> Result<ImagesResponse, Error>
    {
        return await withCheckedContinuation { continuation in
            sendImageEditRequest(image: image, prompt: prompt, size: size, responseFormat: responseFormat, mask: mask, user: user, n: n) {
                result in
                continuation.resume(returning: result)
            }
        }
    }
}
