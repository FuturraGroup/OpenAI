# OpenAI
<p align="center">
  <img width="280" height="280" src="https://user-images.githubusercontent.com/7910769/227876683-fc4b9c8c-61da-44d0-8f9a-1397e4f4e904.png">
</p>

![Swift Workflow](https://github.com/FuturraGroup/OpenAI/actions/workflows/swift.yml/badge.svg)
[![Swift](https://img.shields.io/badge/Swift%20Compatibility-5.5%20%7C%205.6%20%7C%205.7-orange)](https://img.shields.io/badge/Swift%20Compatibility-5.5%20%7C%205.6%20%7C%205.7-orange)
[![Platform](https://img.shields.io/badge/Platform%20Compatibility-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-blue)](https://img.shields.io/badge/Platform%20Compatibility-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-blue)
[![licence](https://img.shields.io/badge/%20licence-MIT-green)](https://img.shields.io/badge/%20licence-MIT-green)

OpenAI is a community-maintained repository containing Swift implementation over [OpenAI public API](https://platform.openai.com/docs/api-reference/).

## Overview
The OpenAI API can be applied to virtually any task that involves understanding or generating natural language or code. We offer a spectrum of models with different levels of power suitable for different tasks, as well as the ability to fine-tune your own custom models. These models can be used for everything from content generation to semantic search and classification.

## Installation

OpenAI is available with CocoaPods and Swift Package Manager.

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate OpenAI into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'OpenAIKit'
```
### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding OpenAI as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/FuturraGroup/OpenAI.git", .branch("main"))
]
```

## Usage

It is encouraged to use environment variables to inject the [OpenAI API key](https://platform.openai.com/account/api-keys), instead of hardcoding it in the source code. This is shown in our [Example project](https://github.com/FuturraGroup/OpenAI/tree/main/Example).

```swift
let apiToken: String = "<Your OpenAI API Token here>"
let organizationName: String = "<Your OpenAI Organization name>"
```
Initialize `OpenAIKit` with your API Token wherever convenient in your project. Organization name is optional.

```swift
import OpenAIKit

public let openAI = OpenAIKit(apiToken: apiToken, organization: organizationName)
```
### Completions
Create a call to the completions API, passing in a text prompt.

```swift
openAI.sendCompletion(prompt: "Hello!", model: .gptV3_5(.davinciText003), maxTokens: 2048) { [weak self] result in
    switch result {
    case .success(let aiResult):
        DispatchQueue.main.async {
            if let text = aiResult.choices.first?.text {
                print("response text: \(text)") //"\n\nHello there, how may I assist you today?"
            }
        }
    case .failure(let error):
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
```
Also supports async/await usage for all methods. Here is example.
```swift
let result = await openAI.sendCompletion(prompt: "Hello!", model: .gptV3_5(.davinciText003), maxTokens: 2048)

switch result {
case .success(let aiResult):
 /// Hadle success response result
    if let text = aiResult.choices.first?.text {
  print("response text: \(text)") //"\n\nHello there, how may I assist you today?"       
    }
case .failure(let error):
 /// Hadle error actions
    print(error.localizedDescription)
}
```
### Chat Completions
Chat completions almost the same as completions, there only few differences:

 - It can understand context with pathing previous chat messages ([read more](https://platform.openai.com/docs/guides/chat)).
 - Response text located in message field of retrieved completion
 - Supports **ONLY** *gpt-3.5-turbo* and *gpt-3.5-turbo-0301* models ([read more about models compatibility](https://platform.openai.com/docs/models/model-endpoint-compatability)).
```swift
openAI.sendChatCompletion(newMessage: AIMessage(role: .user, content: prompt), previousMessages: [], model: .gptV3_5(.gptTurbo), maxTokens: 2048, n: 1, completion: { [weak self] result in
	DispatchQueue.main.async { self?.stopLoading() }
	
	switch result {
	case .success(let aiResult):
		// Handle result actions
		if let text = aiResult.choices.first?.message?.content {
			print(text)
		}
	case .failure(let error):
		// Handle error actions
		print(error.localizedDescription)
	}
})
```
### Stream
You can retrieve response from OpenAI for Completions and Chat Completions in stream partial progress. Don't need to wait time when whole completion response will complete. You can handle and present results in live.

Example call on Chat Completions:

```swift
openAI.sendStreamChatCompletion(newMessage: AIMessage(role: .user, content: "Hello!"), model: .gptV3_5(.gptTurbo), maxTokens: 2048) { result in
	switch result {
	case .success(let streamResult):
		/// Hadle success response result
		if let streamMessage = streamResult.message?.choices.first?.message {
			print("Stream message: \(streamMessage)") //"\n\nHello there, how may I assist you today?"
		}
	case .failure(let error):
		// Handle error actions
		print(error.localizedDescription)
	}
}
```

You can also stop stream manually like this:
```swift
openAI.sendStreamChatCompletion(newMessage: AIMessage(role: .user, content: "Hello!"), model: .gptV3_5(.gptTurbo), maxTokens: 2048) { result in
	switch result {
	case .success(let streamResult):
		/// Hadle success response result
		
		streamResult.stream.stopStream() /// Manually stop stream 
	case .failure(let error):
		// Handle error actions
		print(error.localizedDescription)
	}
}
```

### Generate Image

[DALL·E](https://platform.openai.com/docs/models/dall-e) is a AI system that can create realistic images and art from a description in natural language. We currently support the ability, given a prommpt, to create a new image with a certain size, edit an existing image, or create variations of a user provided image.

The code below demonstrates how you can generate an image using DALL·E:

```swift
openAI.sendImagesRequest(prompt: "bird", size: .size512, n: 1) { [weak self] result in
    
    switch result {
    case .success(let aiResult):
        
        DispatchQueue.main.async {
            if let urlString = aiResult.data.first?.url {
                print("generated image url: \(urlString)")
            }
        }
    case .failure(let error):
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
```
## Contribute

Contributions for improvements are welcomed. Feel free to submit a pull request to help grow the library. If you have any questions, feature suggestions, or bug reports, please send them to [Issues](https://github.com/FuturraGroup/OpenAI/issues).

## License

```
MIT License

Copyright (c) 2023 Futurra Group

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
