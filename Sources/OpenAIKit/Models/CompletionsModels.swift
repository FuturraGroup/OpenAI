//
//  CompletionsModels.swift
//
//
//  Created by Kyrylo Mukha on 03.03.2023.
//

import Foundation

public struct CompletionsRequest: Codable {
	public let model: AIModelType

	public let prompt: String
	
	public var temperature: Double? = nil
	
	public var n: Int? = nil
	
	public var maxTokens: Int? = nil
	
	public var topP: Double? = nil
	
	public var frequencyPenalty: Double? = nil
	
	public var presencePenalty: Double? = nil
	
	public var logprobs: Int? = nil
	
	public var stop: [String]? = nil
	
	public var user: String? = nil
}
