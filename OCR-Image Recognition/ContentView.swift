//
//  ContentView.swift
//  OCR-Image Recognition
//
//  Created by Heical Chandra on 19/08/24.
//

import SwiftUI
import Vision
import AVFoundation
import UIKit

//struct ContentView: View {
//    @StateObject private var ocrViewModel = OCRViewModel()
//    @State private var showCamera = false
//
//    var body: some View {
//        VStack {
//            Text(ocrViewModel.recognizedText)
//                .padding()
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(10)
//                .padding()
//
//            Button(action: {
//                showCamera = true
//            }) {
//                Text("Capture Text")
//                    .font(.title2)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .sheet(isPresented: $showCamera) {
//                CameraView { image in
//                    ocrViewModel.recognizeText(from: image)
//                }
//            }
//        }
//        .padding()
//    }
//}

import SwiftUI

struct ContentView: View {
    @StateObject private var ocrViewModel = OCRViewModel()
    @State private var showCamera = false
    @State private var image: UIImage?

    private let keywords = ["BHA", "AHA", "PHA", "water", "niacinamide"] // Define the keywords here

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
                Text("Bahan yang kamu butuhkan :")
                HStack {
                    ForEach(keywords, id: \.self) { keyword in
                        Text(keyword)
                    }
                }
                HighlightedText(text: ocrViewModel.recognizedText, keywords: keywords)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()

                Text(ocrViewModel.productSuitability ?? "Checking product suitability...")
                    .font(.headline)
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(10)
                    .padding()
            } else {
                Text("No image selected")
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()
            }

            Button(action: {
                showCamera = true
            }) {
                Text("Capture Image")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showCamera) {
                CameraView { capturedImage in
                    image = capturedImage
                    ocrViewModel.recognizeText(from: capturedImage, keywords: keywords)
                }
            }
        }
        .padding()
    }
}

struct HighlightedText: View {
    let text: String
    let keywords: [String]

    var body: some View {
        let words = text.split(separator: " ")

        return Text(buildHighlightedString(from: words, with: keywords))
            .font(.body)
    }

    func buildHighlightedString(from words: [Substring], with keywords: [String]) -> AttributedString {
        var attributedString = AttributedString()

        for word in words {
            var attributedWord = AttributedString(String(word))
            
            if keywords.contains(where: { word.localizedCaseInsensitiveContains($0) }) {
                attributedWord.backgroundColor = .yellow
                attributedWord.foregroundColor = .black
            }
            
            attributedString.append(attributedWord)
            attributedString.append(AttributedString(" ")) // Add space between words
        }

        return attributedString
    }
}



#Preview {
    ContentView()
}
