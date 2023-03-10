//
//  ChatCompletionsModels.swift
//
//
//  Created by Kyrylo Mukha on 10.03.2023.
//

import Foundation

public struct ChatCompletionsRequest: Codable {
	public let model: AIModelType

	public let messages: [AIMessage]
	
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
