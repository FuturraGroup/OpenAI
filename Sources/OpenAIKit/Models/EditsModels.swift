//
//  EditsModels.swift
//
//
//  Created by Kyrylo Mukha on 03.03.2023.
//

import Foundation

public struct EditsRequest: Codable {
	public let model: AIModelType

	public let input: String

	public let instruction: String

	public var n: Int? = nil

	public var temperature: Double? = nil

	public var topP: Double? = nil
}
