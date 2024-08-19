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

class OCRViewModel: ObservableObject {
    @Published var recognizedText: String = ""

    func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Error recognizing text: \(error.localizedDescription)")
                return
            }
            self.processRecognitionResults(request.results)
        }

        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform text recognition: \(error.localizedDescription)")
        }
    }

    private func processRecognitionResults(_ results: [Any]?) {
        guard let results = results as? [VNRecognizedTextObservation] else { return }

        var recognizedText = ""
        for observation in results {
            guard let topCandidate = observation.topCandidates(1).first else { continue }
            recognizedText += topCandidate.string + "\n"
        }

        DispatchQueue.main.async {
            self.recognizedText = recognizedText
        }
    }
}
