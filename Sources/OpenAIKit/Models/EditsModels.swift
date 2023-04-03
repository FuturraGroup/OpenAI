//
//  EditsModels.swift
//
//
//  Created by Kyrylo Mukha on 03.03.2023.
//

import Foundation

public struct EditsRequest: Codable {
	/// ID of the model to use.
	public let model: AIModelType
	/// The input text to use as a starting point for the edit.
	public let input: String
	/// The instruction that tells the model how to edit the prompt.
	public let instruction: String
	/// How many completions to generate for each prompt.
	public var n: Int? = nil
	/// What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or `topP` but not both.
	public var temperature: Double? = nil
	/// An alternative to sampling with `temperature`, called nucleus sampling, where the model considers the results of the tokens with `topP` probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or `temperature` but not both.
	public var topP: Double? = nil
}
