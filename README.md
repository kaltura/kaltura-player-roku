# Kaltura Player Roku Platform - Cloud TV and OVP Media Players Based on the [PlayKit ROKU Player]

The Kaltura Player utilizes a highly modular approach for creating a powerful media player.
Each functionality of the player is isolated into separate packages, which are designed to deliver a specific set of abilities.
This approach enables extensibility, simplicity and easy maintenance.

The Kaltura Player integrates:

- [PlayKit ROKU ](https://github.com/kaltura/playkit-js) - The core library.
- [PlayKit ROKU Providers](https://github.com/kaltura/playkit-roku-providers) as the backend media providers.
- [PlayKit ROKU Analytics](https://github.com/kaltura/playkit-roku-ott-analytics) plugin for analytics.

The Kaltura Player exposes two different players: the _Kaltura OVP Player_ and _Kaltura Cloud TV Player_. Each player integrates its related packages, as you can see in the following table:

> \* Needs to be configured.

The Kaltura Player is written in [brightscript].

[playkit roku player]: https://github.com/kaltura/playkit-roku

## Getting Started

### Installing

First, clone and run [yarn] to install dependencies:

[yarn]: https://yarnpkg.com/lang/en/

```
git clone https://github.com/kaltura/kaltura-player-js.git
cd kaltura-player-js
yarn install
```


### Building and Deploy

Modify the rokudeploy.json set your Roku ip and password
 
Next, build and deploy:
```
yarn deploy
```

For debugging 
```
yarn debug
```

For building 
```
yarn build
```

### Embed the Player In Your Test Page

add the bundle as a script tag in your page
```xml
<ComponentLibrary id="KalturaPlayerLib" uri="Your uri for this lib" />

```brightscript
<script type="text/brightscript" >
<![CDATA[

'sample configuration 
configuration = {
    provider: {
        "partnerId":"Enter partner id"
        "env":{
            "serviceUrl":"Enter your service url"
        }
    },
    playback:{
        options:{
'           configuration for meta data element (video node content attribute)
'           https://developer.roku.com/docs/developer-program/getting-started/architecture/content-metadata.md 
            "rokuConfig": {
                "ClipStart":invalid, 'number
                "ClipEnd":invalid,  'number
                "preferredaudiocodec":invalid 'boolean
            }
        },
       "startTime": "playback start time", 'number
        "preload": "if prebuffer before playing", 'boolean
        "autoplay": "if to start play immediately", 'boolean
        "loop": "play in continuous", 'boolean
        "muted": "if to muted the video", 'boolean
    }
}

'Step 1 - load and wait until kaltura player roku is loaded 

m._kalturaPlayerLib = m.top.FindNode("KalturaPlayerLib")
m._kalturaPlayerLib.observeField("loadStatus", "_onLoadStatusChanged")

sub _onLoadStatusChanged()
    print "loadstatus for kaltura player " m._kalturaPlayerLib.loadStatus
    if (m._kalturaPlayerLib.loadStatus = "ready")
    
         m._kalturaPlayerLib.unobserveField("loadStatus")
        
         m.kalturaPlayer = CreateObject("roSGNode", "KalturaPlayerLib:KalturaPlayer")
         m.top.appendChild(m.kalturaPlayer)
         m.kalturaPlayer.setFocus(true)
    
    endif
end sub

'Step 2 - kaltura player roku wait until all async sources will finish loaded
'listen to those events and continue, add those methods loaded and ready to interface to allow this listeners
kalturaPlayerEvent = m.kalturaPlayer.callFunc("getKalturaPlayerEvents")
m.kalturaPlayer.callFunc("addEventListener", kalturaPlayerEvent.KALTURA_PLAYER_LOADED, m.top, "loaded")
m.kalturaPlayer.callFunc("addEventListener", kalturaPlayerEvent.MEDIA_LOADED, m.top, "ready")

'Step 3 - wait until all async sources will finish loaded and setup the player and set the sources
function loaded(event as string, payload as object)
    m.kalturaPlayer.callFunc("setup", configuration)

    'setMedia is relevant for media that doesn't come from kaltura backend
    'Sample for media config
    'media = {
    '   sources:{
    '       {
    '         "poster": "poster url",
    '         "hls": [
    '           {
    '             "id": "strean id",
    '             "url": "manifest url",
    '             "mimetype": "application/x-mpegURL"
    '           }
    '         ],
    '         "dash": [
    '           {
    '             "id": "strean id",
    '             "url": "manifest url",
    '             "mimetype": "application/dash+xml"
    '             'drm data format if needed
    '              "drmData": [
    '                 {
    '                   "licenseUrl": "licence url",
    '                   "scheme": "com.microsoft.playready"
    '                 },
    '                 {
    '                   "licenseUrl": "licence url",
    '                   "scheme": "com.widevine.alpha"
    '                 }
    '               ]
    '           }
    '         ],
    '         "progressive": [
    '           {
    '             "id": "strean id",
    '             "url": "manifest url",
    '             "mimetype": "video/mp4",
    '           }
    '         ],
    '         "id": "media id", 'string
    '         "duration": duration, 'number
    '         "type": "Vod", 'string Vod/Live
    '         "dvr": false, 'is DVR
    '       }'
    '   },
    '   session:{},
    '   plugins:{}
    '}
    '
    'm.kalturaPlayer.callFunc("setMedia", media)
    'loadMedia to get media from kaltura backend by entryId, extra parameters explained later
    m.kalturaPlayer.callFunc("loadMedia", {
        "entryId": "Your entry id"
    })
endfunction

'Step 4 - wait until the media is ready to play 
function ready(event as string, payload as object)'
    m.kalturaPlayer.callFunc("play")
end function

]]>
</script>
```

**load Media Parameters**

| Name                 | Type            | Required | Description                            | Possible Values                                        | Default Value |
| -------------------- | --------------- | -------- | -------------------------------------- | ------------------------------------------------------ | ------------- |
| `entryId`            | `string`        | V        | The entry ID of the media              |
| `mediaType`          | `string`        |          | The type of the specific media         | `"media"`, `"epg"`, `"recording"`                      | `"media"`     |
| `assetReferenceType` | `string`        |          | The asset type of the specific media   | `"media"`, `"epg_internal"`, `"epg_external"`          | `"media"`     |
| `contextType`        | `string`        |          | The playback context type              | `"PLAYBACK"`, `"CATCHUP"`, `"START_OVER"`, `"TRAILER"` | `"PLAYBACK"`  |
| `ks`                 | `string`        |          | The KS (Kaltura Session) secret        |
| `protocol`           | `string`        |          | The protocol of the specific media     | `"https"`, `"http"`                                    |
| `fileIds`            | `string`        |          | List of comma-separated media file IDs |
| `formats`            | `Array<string>` |          | Device types as defined in the system. |

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/kaltura/playkit-roku-providers/tags).

## License

This project is licensed under the AGPL-3.0 License - see the [LICENSE](LICENSE) file for details
