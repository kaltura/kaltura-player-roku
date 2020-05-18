sub init()
    m.top.setFocus(true)
    m.config = {
        provider: {
            "partnerId":"3009"
            "serviceUrl":"https://rest-us.ott.kaltura.com/v4_5/api_v3/"
        },
        sources: {
            "captions": [
                {
                    "default": false,
                    "type": "srt",
                    "language": "en",
                    "label": "Eng",
                    "url": "https://cdnsecakmi.kaltura.com/api_v3/index.php/service/caption_captionAsset/action/serve/captionAssetId/1_jifoy4sp"
                },
                {
                    "default": false,
                    "type": "srt",
                    "language": "nl",
                    "label": "Ger",
                    "url": "https://cdnsecakmi.kaltura.com/api_v3/index.php/service/caption_captionAsset/action/serve/captionAssetId/1_gdca0mmn"
                },
                {
                    "default": false,
                    "type": "srt",
                    "language": "ru",
                    "label": "Rus",
                    "url": "https://cdnsecakmi.kaltura.com/api_v3/index.php/service/caption_captionAsset/action/serve/captionAssetId/1_cgz16ahe"
                }
            ]
        },
        "playback": {
            "audioLanguage": "",
            "textLanguage": "",
            "useNativeTextTrack": false,
            "enableCEA708Captions": false,
            "captionsTextTrack1Label": "English",
            "captionsTextTrack1LanguageCode": "en",
            "captionsTextTrack2Label": "Spanish",
            "captionsTextTrack2LanguageCode": "es",
            "volume": 1,
            "startTime": -1,
            "playsinline": false,
            "preload": false,
            "autoplay": false,
            "loop": false,
            "allowMutedAutoPlay": false,
            "muted": false,
            "pictureInPicture": true,
            "options": {
                "html5": {
                    "hls": {},
                    "dash": {},
                    "native": {}
                }
            },
            "preferNative": {
                "hls": false,
                "dash": false
            },
            "inBrowserFullscreen": false,
            "playAdsWithMSE": false,
            "streamPriority": [
                {
                    "format": "hls"
                },
                {
                    "format": "dash"
                },
                {
                    "format": "progressive"
                },
                {
                    "format": "hls"
                }
            ]
        }
    }

    m.kalturaPlayer = m.top.findNode("kaltura-player-roku")
    kalturaPlayerEvent = m.kalturaPlayer.callFunc("getKalturaPlayerEvents")
    m.kalturaPlayer.callFunc("addEventListener", kalturaPlayerEvent.KALTURA_PLAYER_LOADED, m.top, "loaded")
    m.kalturaPlayer.callFunc("addEventListener", kalturaPlayerEvent.MEDIA_LOADED, m.top, "ready")

end sub

function eventHandler(event as string, payload as object)
    print event " " payload
    if payload <> invalid then print payload["data"]
end function

function loaded(event as string, payload as object)
    print "loaded"
    kalturaPlayerEvent = m.kalturaPlayer.callFunc("getKalturaPlayerEvents")
    for each kalturaEvent in kalturaPlayerEvent
        m.kalturaPlayer.callFunc("addEventListener", kalturaPlayerEvent[kalturaEvent], m.top, "eventHandler")
    end for
    m.kalturaPlayer.callFunc("setup", m.config)
    m.kalturaPlayer.callFunc("loadMedia", {
        "entryId":"548569"
    })

end function

function ready(event as string, payload as object)
    print "ready"
    m.kalturaPlayer.callFunc("play")
end function
