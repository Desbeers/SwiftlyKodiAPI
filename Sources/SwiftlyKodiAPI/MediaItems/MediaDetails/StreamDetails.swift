//
//  File.swift
//  
//
//  Created by Nick Berendsen on 06/05/2022.
//

import Foundation

/// A struct for the streaming details of a media item
public struct StreamDetails: Codable, Identifiable, Hashable {
    /// Make it identifiable
    public var id = UUID()
    /// The array of audio details
    public var audio: [Audio] = []
    /// The array of subtitles details
    public var subtitle: [Subtitle] = []
    /// The array of video details
    public var video: [Video] = []
    /// The coding keys
    enum CodingKeys: String, CodingKey {
        case audio, subtitle, video
    }
    /// The audio details struct
    public struct Audio: Codable, Identifiable, Hashable {
        /// Make it identifiable
        public var id = UUID()
        public var channels: Int = 0
        public var codec: String = ""
        public var language: String = ""
        enum CodingKeys: String, CodingKey {
            case channels, codec, language
        }
    }
    /// The subtitles details struct
    public struct Subtitle: Codable, Identifiable, Hashable {
        /// Make it identifiable
        public var id = UUID()
        public var language: String = ""
        enum CodingKeys: String, CodingKey {
            case language
        }
    }
    /// The video details struct
    public struct Video: Codable, Identifiable, Hashable {
        /// Make it identifiable
        public var id = UUID()
        public var aspect: Double = 0
        public var codec: String = ""
        public var duration: Int = 0
        public var height: Int = 0
        public var language: String = ""
        public var stereomode: String = ""
        public var width: Int = 0
        enum CodingKeys: String, CodingKey {
            case aspect, codec, duration, height, language, stereomode, width
        }
    }
}

extension StreamDetails {
    
    /// A calculated label for the video details
    public var videoLabel: String {
        if let stream = video.first {
            switch stream.width  {
            case 1919...:
                return "Full HD (1080p), \(stream.codec.uppercased() )"
            case 720...:
                return "HD (720p), \(stream.codec.uppercased() )"
            default:
                return "SD, \(stream.codec.uppercased() )"
            }
        }
        /// Fallback
        return "Unknown"
    }

    /// A calculated label for the subtitles
    public var subtitleLabel: String {
        var label: [String] = []
        for stream in subtitle where !stream.language.isEmpty {
            label.append("\(languageName(from: stream.language))")
        }
        return label.joined(separator: " | ")
    }
    
    /// A calculated label for the audio details
    public var audioLabel: String {
        var label: [String] = []
        for stream in audio {
            label.append("\(stream.channels) channels \(stream.codec.uppercased())")
        }
        return label.joined(separator: " | ")
    }
    
    /// Helper to convert a language code to a full name
    /// - Parameter languageCode: The language code to convert
    /// - Returns: A string with a full name
    func languageName(from languageCode: String) -> String {
        return (Locale.current as NSLocale).displayName(forKey: .languageCode, value: languageCode) ?? languageCode
    }
}
