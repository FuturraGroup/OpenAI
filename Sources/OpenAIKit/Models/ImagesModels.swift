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
