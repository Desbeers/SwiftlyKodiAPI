//
//  Setting+ID.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Setting {

    // swiftlint:disable type_name
    /// The ID of the Kodi setting (SwiftlyKodi Type)
    enum ID: String, Codable, Sendable {

        /// A setting SwiftlyKodiAPI doesn't know about
        case unknown

        /// No ID (used for parent value)
        case none

        // MARK: interface + skin

        case lookAndFeelSkin = "lookandfeel.skin"
        case lookAndFeelSkinTheme = "lookandfeel.skintheme"
        case lookAndFeelSkinColors = "lookandfeel.skincolors"
        case lookAndFeelFont = "lookandfeel.font"
        case lookAndFeelSkinZoom = "lookandfeel.skinzoom"
        case lookAndFeelEnableRssFeeds = "lookandfeel.enablerssfeeds"
        case lookAndFeelRssEdit = "lookandfeel.rssedit"

        // MARK: interface + regional

        case localeLanguage = "locale.language"
        case localeCountry = "locale.country"

        // MARK: media + general

        case filelistsIgnoreTheWhenSorting = "filelists.ignorethewhensorting"

        // MARK: media + video

        case videolibraryGroupMovieSets = "videolibrary.groupmoviesets"
        case videolibraryGroupSingleItemSets = "videolibrary.groupsingleitemsets"

        case videolibraryShowUwatchedPlots = "videolibrary.showunwatchedplots"

        // MARK: player + videoplayer

        case videoplayerAutoPlayNextItem = "videoplayer.autoplaynextitem"

        // MARK: player + musicplayer

        /// Read the ReplayGain information encoded in your audio files
        case musicPlayerReplayGainType = "musicplayer.replaygaintype"
        /// Reference volume (PreAmp level) to use for files with encoded ReplayGain information
        case musicplayerReplayGainPreamp = "musicplayer.replaygainpreamp"
        /// Reference volume (PreAmp level) to use for files without encoded ReplayGain information
        case musicplayerReplayGainNoGainPreamp = "musicplayer.replaygainnogainpreamp"
        /// Play file at lower volume, if necessary, to avoid audio limiting clipping protection
        case musicplayerReplayGainAvoidClipping = "musicplayer.replaygainavoidclipping"
        /// Crossfade between songs
        case musicplayerCrossfade = "musicplayer.crossfade"
        /// Allow crossfading to occur when both tracks are from the same album
        case musicplayerCrossfadeAlbumTracks = "musicplayer.crossfadealbumtracks"

        // MARK: services + general

        case servicesDevicename = "services.devicename"
    }
    // swiftlint:enable type_name
}
