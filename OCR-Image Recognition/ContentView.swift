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

struct ContentView: View {
    @StateObject private var ocrViewModel = OCRViewModel()
    @State private var showCamera = false

    var body: some View {
        VStack {
            Text(ocrViewModel.recognizedText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()

            Button(action: {
                showCamera = true
            }) {
                Text("Capture Text")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showCamera) {
                CameraView { image in
                    ocrViewModel.recognizeText(from: image)
                }
            }
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
