# ``SwiftlyKodiAPI``

A Swift framework to talk to Kodi's JSON-RPC API

## Overview

*JSON-RPC is a HTTP- and/or raw TCP socket-based interface for communicating with [Kodi](https://kodi.tv).*

It supports version 12 of the interface and that is the stable version of Kodi's JSON-RPC API and is published with the release of v19 (Matrix).

## Limitations

It is currently very much work in progress. I'm going to use this framework in my Kodi Music Remote application [Kodio](https://github.com/Desbeers/Kodio). 

## Namespaces and Global Types

This framework tries to follow Kodi's namespaces and global types as much as possible.

See the [Kodi JSON-RPC API](https://kodi.wiki/view/JSON-RPC_API/v12).

## Topics

### Kodi Namespaces

- ``Application``
- ``AudioLibrary``
- ``Files``
- ``Player``
- ``Playlist``
- ``Settings``
- ``VideoLibrary``
- ``XBMC``

### Kodi Global Types

- ``Application``
- ``Audio``
- ``Files``
- ``Library``
- ``List``
- ``Media``
- ``Notifications``
- ``Player``
- ``Playlist``
- ``Setting``
- ``Video``


### Observable Classes

- ``KodiConnector``
- ``KodiPlayer``

### SwiftUI

Well, I love SwiftUI and I actualy have no clue about Appkit or UIkit

- ``KodiArt``
- ``KodiPlayerView``
- ``MediaButtons``
