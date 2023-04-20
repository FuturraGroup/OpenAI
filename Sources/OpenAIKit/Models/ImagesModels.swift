//
//  ImagesModels.swift
//
//
//  Created by Kyrylo Mukha on 03.03.2023.
//

import Foundation

public typealias AIImageSize = String

public extension AIImageSize {
	static let size256 = "256x256"
	static let size512 = "512x512"
	static let size1024 = "1024x1024"
}

public struct ImageRequest: Codable {
	/// The prompt to generate completions for, encoded as a string, array of strings, array of tokens, or array of token arrays.
	public var prompt: String
	/// How many completions to generate for each prompt.
	public var n: Int? = nil
	/// The size of the generated images. Must be one of `size256`, `size512`, or `size1024`.
	public var size: AIImageSize = .size1024
	/// A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
	public var user: String? = nil
}

public struct ImagesResponse: Codable {
	public struct AIImage: Codable {
		public let url: String
	}

	public let created: TimeInterval
	public var data: [AIImage]
}

public struct ImageEditRequest: Codable {
    /// The image to edit. Must be a valid PNG file, less than 4MB, and square. If mask is not provided, image must have transparency, which will be used as the mask.
    public var image: String
    /// An additional image whose fully transparent areas (e.g. where alpha is zero) indicate where image should be edited. Must be a valid PNG file, less than 4MB, and have the same dimensions as image.
    public var mask: String?
    /// A text description of the desired image(s). The maximum length is 1000 characters.
    public var prompt: String
    /// The number of images to generate. Must be between 1 and 10.
    public var n: Int? = nil
    /// The size of the generated images. Must be one of `size256`, `size512`, or `size1024`.
    public var size: AIImageSize = .size1024
    /// The format in which the generated images are returned. Must be one of `url` or `b64_json`
    /// DEFAULT: url
    public var responseFormat: String?
    /// A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
    public var user: String? = nil
}

public struct ImageEditResponse: Codable {
    public struct AIImage: Codable {
        public let url: String
    }
    
    public let created: TimeInterval
    public var data: [AIImage]
}
