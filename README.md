# OpenAI

![logo](https://user-images.githubusercontent.com/7910769/221990786-c1de6c7f-d8cd-40bf-b3fd-d5d279676fb8.png)
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
Create a call to the completions API, passing in a text prompt.

```swift
openAI.sendCompletion(prompt: "Hello!", model: .gptV3_5(.gptTurbo), maxTokens: 2048) { [weak self] result in
    
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
Also supports async/await usage for all methods.
```swift
let result = await openAI.sendCompletion(prompt: "Hello!", model: .gptV3_5(.gptTurbo), maxTokens: 2048)

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
