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
	public var prompt: String
	public var n: Int? = nil
	public var size: AIImageSize = .size1024
	public var user: String? = nil
}

public struct ImagesResponse: Codable {
	public struct AIImage: Codable {
		public let url: String
	}

	public let created: TimeInterval
	public var data: [AIImage]
}
