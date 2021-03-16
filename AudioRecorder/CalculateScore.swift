//
//  CalculateScore.swift
//  AudioRecorder
//
//  Created by Dieter Kunze on 3/16/21.
//

import Foundation
import NaturalLanguage

class CalculateScore {
    
    ///Keyword is the word given to the user
    func computeTotalDistance(keyword: String, userInput: [String]) -> Double {
        var distanceTally: Double = 0
        for x in userInput {
            if let embedding = NLEmbedding.wordEmbedding(for: .english) {
                print("Distance between '\(keyword.lowercased())' & '\(x)' = \(embedding.distance(between: x.lowercased(), and: keyword.lowercased()))")
                distanceTally += embedding.distance(between: x.lowercased(), and: keyword.lowercased())
            }
        }
        return distanceTally
    }
    
}
