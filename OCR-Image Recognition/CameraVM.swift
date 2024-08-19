//
//  CameraVM.swift
//  OCR-Image Recognition
//
//  Created by Heical Chandra on 19/08/24.
//
import SwiftUI
import Vision
import AVFoundation
import UIKit

//class OCRViewModel: ObservableObject {
//    @Published var recognizedText: String = ""
//
//    func recognizeText(from image: UIImage) {
//        guard let cgImage = image.cgImage else { return }
//
//        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        let request = VNRecognizeTextRequest { (request, error) in
//            if let error = error {
//                print("Error recognizing text: \(error.localizedDescription)")
//                return
//            }
//            self.processRecognitionResults(request.results)
//        }
//
//        do {
//            try requestHandler.perform([request])
//        } catch {
//            print("Failed to perform text recognition: \(error.localizedDescription)")
//        }
//    }
//
//    private func processRecognitionResults(_ results: [Any]?) {
//        guard let results = results as? [VNRecognizedTextObservation] else { return }
//
//        var recognizedText = ""
//        for observation in results {
//            guard let topCandidate = observation.topCandidates(1).first else { continue }
//            recognizedText += topCandidate.string + "\n"
//        }
//
//        DispatchQueue.main.async {
//            self.recognizedText = recognizedText
//        }
//    }
//}

import SwiftUI
import Vision
import UIKit

class OCRViewModel: ObservableObject {
    @Published var recognizedText: String = ""
    @Published var productSuitability: String?

    func recognizeText(from image: UIImage, keywords: [String]) {
        guard let cgImage = image.cgImage else { return }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Error recognizing text: \(error.localizedDescription)")
                return
            }
            self.processRecognitionResults(request.results, keywords: keywords)
        }

        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform text recognition: \(error.localizedDescription)")
        }
    }

    private func processRecognitionResults(_ results: [Any]?, keywords: [String]) {
        guard let results = results as? [VNRecognizedTextObservation] else { return }

        var recognizedText = ""
        var keywordCount = 0

        for observation in results {
            guard let topCandidate = observation.topCandidates(1).first else { continue }
            recognizedText += topCandidate.string + "\n"
            
            for keyword in keywords {
                if topCandidate.string.localizedCaseInsensitiveContains(keyword) {
                    keywordCount += 1
                }
            }
        }

        DispatchQueue.main.async {
            self.recognizedText = recognizedText
            self.calculateProductSuitability(keywordCount: keywordCount, totalKeywords: keywords.count)
        }
    }

    private func calculateProductSuitability(keywordCount: Int, totalKeywords: Int) {
        if keywordCount > 0 {
            let suitabilityPercentage = Double(keywordCount) / Double(totalKeywords) * 100
            self.productSuitability = "This product is suitable with \(Int(suitabilityPercentage))% of the ingredients."
        } else {
            self.productSuitability = "This product does not contain the required ingredients."
        }
    }
}
