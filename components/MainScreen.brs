sub init()

  m.provider = CreateObject("roSGNode", "PlaykitProviderLib:OTTProvider")
  m.provider.observeField("responseData", "getResponse")

  m.provider.callFunc("initialize",{
    "partnerId":"3009"
'    "serviceUrl":"https://api-preprod.ott.kaltura.com/v5_2_8/api_v3"
    "serviceUrl":"https://rest-us.ott.kaltura.com/v4_5/api_v3/"
  })

  ' ################################################################
  ' simple media entry
  ' ################################################################

  m.provider.callFunc("getMediaConfig",{
    "entryId":"548569"
  })

  m.config = {
    sources: {
      "poster": "http://externaltests.dev.kaltura.com/player/library_Player_V3/smartPages/images/Kaltura_poster.png",
      "options": {},
'      "hls": [
'        {
'          "id": "0_tvhgji01_861,applehttp",
'          "url": "http://cdntesting.qa.mkaltura.com/p/1091/sp/109100/playManifest/entryId/0_tvhgji01/protocol/http/format/applehttp/flavorIds/0_ti5q845h,0_in7dud5m,0_pwynq5md,0_vefoqxnv,0_lbkn1m7u/a.m3u8?uiConfId=15215933&playSessionId=ef0ba6a2-5b5d-33a0-b9f0-c8558d63cf62:22ef212a-41f7-d72b-6f65-fceeb7888a08&referrer=aHR0cDovL2V4dGVybmFsdGVzdHMuZGV2LmthbHR1cmEuY29tL3BsYXllci9saWJyYXJ5X1BsYXllcl9WMy9zbWFydFBhZ2VzL1BsYXllcl9WM19nZW5lcmljX3BhZ2UucGhwP2NkblVybD10ZXN0JnBhcnRuZXJJZD0xMDkxJnVpQ29uZklkPXRlc3RSZWcmc2VsZWN0ZWRVaUNvbmY9MTUyMTU5MzMmZW50cnlJZD10c3RicCZzZWxlY3RlZEVudHJ5SWQ9MF90dmhnamkwMSZjb21wTHN0PSZjb21wVmVyPSZjb21wVmVycz0mbG9ncz1kZWImcGxsc3RCeUVudElkPSZwbGxzdElkPSZjbnREd25UVFM9JmNudER3bkR1cj0mZW5nMT1odG1sJmVuZzI9aHRtbCZlbmczPWh0bWwmc3RQcjE9JnN0UHIyPSZzdFByMz0mdHh0TGFuZz1kZWZhdWx0JmF1ZGlvTGFuZz1kZWZhdWx0JmFfcz0wJnN0clBvcz0mYWRUYWc9bm9BZCZhZEFmdFRpbWU9Jm51bVJlZGlyZWN0cz0mZGFpPW5vRGFpJmJ1bXBlcj1ub0J1bXAmYnVtcFBvcz1kZWZCdW1wJldNUGxhY2U9&clientTag=html5:v0.53.4",
'          "mimetype": "application/x-mpegURL"
'        }
'      ],
'      "dash": [
'        {
'          "id": "0_tvhgji01_911,mpegdash",
'          "url": "http://cdntesting.qa.mkaltura.com/p/1091/sp/109100/playManifest/entryId/0_tvhgji01/protocol/http/format/mpegdash/flavorIds/0_pwynq5md,0_vefoqxnv,0_lbkn1m7u/a.mpd?uiConfId=15215933&playSessionId=ef0ba6a2-5b5d-33a0-b9f0-c8558d63cf62:22ef212a-41f7-d72b-6f65-fceeb7888a08&referrer=aHR0cDovL2V4dGVybmFsdGVzdHMuZGV2LmthbHR1cmEuY29tL3BsYXllci9saWJyYXJ5X1BsYXllcl9WMy9zbWFydFBhZ2VzL1BsYXllcl9WM19nZW5lcmljX3BhZ2UucGhwP2NkblVybD10ZXN0JnBhcnRuZXJJZD0xMDkxJnVpQ29uZklkPXRlc3RSZWcmc2VsZWN0ZWRVaUNvbmY9MTUyMTU5MzMmZW50cnlJZD10c3RicCZzZWxlY3RlZEVudHJ5SWQ9MF90dmhnamkwMSZjb21wTHN0PSZjb21wVmVyPSZjb21wVmVycz0mbG9ncz1kZWImcGxsc3RCeUVudElkPSZwbGxzdElkPSZjbnREd25UVFM9JmNudER3bkR1cj0mZW5nMT1odG1sJmVuZzI9aHRtbCZlbmczPWh0bWwmc3RQcjE9JnN0UHIyPSZzdFByMz0mdHh0TGFuZz1kZWZhdWx0JmF1ZGlvTGFuZz1kZWZhdWx0JmFfcz0wJnN0clBvcz0mYWRUYWc9bm9BZCZhZEFmdFRpbWU9Jm51bVJlZGlyZWN0cz0mZGFpPW5vRGFpJmJ1bXBlcj1ub0J1bXAmYnVtcFBvcz1kZWZCdW1wJldNUGxhY2U9&clientTag=html5:v0.53.4",
'          "mimetype": "application/dash+xml"
'        }
'      ],
'      "progressive": [
'        {
'          "id": "0_ti5q845h261,url",
'          "url": "http://cdntesting.qa.mkaltura.com/p/1091/sp/109100/playManifest/entryId/0_tvhgji01/protocol/http/format/url/flavorIds/0_ti5q845h/a.mp4?uiConfId=15215933&playSessionId=ef0ba6a2-5b5d-33a0-b9f0-c8558d63cf62:22ef212a-41f7-d72b-6f65-fceeb7888a08&referrer=aHR0cDovL2V4dGVybmFsdGVzdHMuZGV2LmthbHR1cmEuY29tL3BsYXllci9saWJyYXJ5X1BsYXllcl9WMy9zbWFydFBhZ2VzL1BsYXllcl9WM19nZW5lcmljX3BhZ2UucGhwP2NkblVybD10ZXN0JnBhcnRuZXJJZD0xMDkxJnVpQ29uZklkPXRlc3RSZWcmc2VsZWN0ZWRVaUNvbmY9MTUyMTU5MzMmZW50cnlJZD10c3RicCZzZWxlY3RlZEVudHJ5SWQ9MF90dmhnamkwMSZjb21wTHN0PSZjb21wVmVyPSZjb21wVmVycz0mbG9ncz1kZWImcGxsc3RCeUVudElkPSZwbGxzdElkPSZjbnREd25UVFM9JmNudER3bkR1cj0mZW5nMT1odG1sJmVuZzI9aHRtbCZlbmczPWh0bWwmc3RQcjE9JnN0UHIyPSZzdFByMz0mdHh0TGFuZz1kZWZhdWx0JmF1ZGlvTGFuZz1kZWZhdWx0JmFfcz0wJnN0clBvcz0mYWRUYWc9bm9BZCZhZEFmdFRpbWU9Jm51bVJlZGlyZWN0cz0mZGFpPW5vRGFpJmJ1bXBlcj1ub0J1bXAmYnVtcFBvcz1kZWZCdW1wJldNUGxhY2U9&clientTag=html5:v0.53.4",
'          "mimetype": "video/mp4",
'          "bandwidth": 481280,
'          "width": 640,
'          "height": 360,
'          "label": "Undefined"
'        },
'        {
'          "id": "0_in7dud5m261,url",
'          "url": "http://cdntesting.qa.mkaltura.com/p/1091/sp/109100/playManifest/entryId/0_tvhgji01/protocol/http/format/url/flavorIds/0_in7dud5m/a.mp4?uiConfId=15215933&playSessionId=ef0ba6a2-5b5d-33a0-b9f0-c8558d63cf62:22ef212a-41f7-d72b-6f65-fceeb7888a08&referrer=aHR0cDovL2V4dGVybmFsdGVzdHMuZGV2LmthbHR1cmEuY29tL3BsYXllci9saWJyYXJ5X1BsYXllcl9WMy9zbWFydFBhZ2VzL1BsYXllcl9WM19nZW5lcmljX3BhZ2UucGhwP2NkblVybD10ZXN0JnBhcnRuZXJJZD0xMDkxJnVpQ29uZklkPXRlc3RSZWcmc2VsZWN0ZWRVaUNvbmY9MTUyMTU5MzMmZW50cnlJZD10c3RicCZzZWxlY3RlZEVudHJ5SWQ9MF90dmhnamkwMSZjb21wTHN0PSZjb21wVmVyPSZjb21wVmVycz0mbG9ncz1kZWImcGxsc3RCeUVudElkPSZwbGxzdElkPSZjbnREd25UVFM9JmNudER3bkR1cj0mZW5nMT1odG1sJmVuZzI9aHRtbCZlbmczPWh0bWwmc3RQcjE9JnN0UHIyPSZzdFByMz0mdHh0TGFuZz1kZWZhdWx0JmF1ZGlvTGFuZz1kZWZhdWx0JmFfcz0wJnN0clBvcz0mYWRUYWc9bm9BZCZhZEFmdFRpbWU9Jm51bVJlZGlyZWN0cz0mZGFpPW5vRGFpJmJ1bXBlcj1ub0J1bXAmYnVtcFBvcz1kZWZCdW1wJldNUGxhY2U9&clientTag=html5:v0.53.4",
'          "mimetype": "video/mp4",
'          "bandwidth": 685056,
'          "width": 640,
'          "height": 360,
'          "label": "Undefined"
'        },
'        {
'          "id": "0_pwynq5md261,url",
'          "url": "http://cdntesting.qa.mkaltura.com/p/1091/sp/109100/playManifest/entryId/0_tvhgji01/protocol/http/format/url/flavorIds/0_pwynq5md/a.mp4?uiConfId=15215933&playSessionId=ef0ba6a2-5b5d-33a0-b9f0-c8558d63cf62:22ef212a-41f7-d72b-6f65-fceeb7888a08&referrer=aHR0cDovL2V4dGVybmFsdGVzdHMuZGV2LmthbHR1cmEuY29tL3BsYXllci9saWJyYXJ5X1BsYXllcl9WMy9zbWFydFBhZ2VzL1BsYXllcl9WM19nZW5lcmljX3BhZ2UucGhwP2NkblVybD10ZXN0JnBhcnRuZXJJZD0xMDkxJnVpQ29uZklkPXRlc3RSZWcmc2VsZWN0ZWRVaUNvbmY9MTUyMTU5MzMmZW50cnlJZD10c3RicCZzZWxlY3RlZEVudHJ5SWQ9MF90dmhnamkwMSZjb21wTHN0PSZjb21wVmVyPSZjb21wVmVycz0mbG9ncz1kZWImcGxsc3RCeUVudElkPSZwbGxzdElkPSZjbnREd25UVFM9JmNudER3bkR1cj0mZW5nMT1odG1sJmVuZzI9aHRtbCZlbmczPWh0bWwmc3RQcjE9JnN0UHIyPSZzdFByMz0mdHh0TGFuZz1kZWZhdWx0JmF1ZGlvTGFuZz1kZWZhdWx0JmFfcz0wJnN0clBvcz0mYWRUYWc9bm9BZCZhZEFmdFRpbWU9Jm51bVJlZGlyZWN0cz0mZGFpPW5vRGFpJmJ1bXBlcj1ub0J1bXAmYnVtcFBvcz1kZWZCdW1wJldNUGxhY2U9&clientTag=html5:v0.53.4",
'          "mimetype": "video/mp4",
'          "bandwidth": 988160,
'          "width": 960,
'          "height": 540,
'          "label": "Undefined"
'        },
'        {
'          "id": "0_vefoqxnv261,url",
'          "url": "http://cdntesting.qa.mkaltura.com/p/1091/sp/109100/playManifest/entryId/0_tvhgji01/protocol/http/format/url/flavorIds/0_vefoqxnv/a.mp4?uiConfId=15215933&playSessionId=ef0ba6a2-5b5d-33a0-b9f0-c8558d63cf62:22ef212a-41f7-d72b-6f65-fceeb7888a08&referrer=aHR0cDovL2V4dGVybmFsdGVzdHMuZGV2LmthbHR1cmEuY29tL3BsYXllci9saWJyYXJ5X1BsYXllcl9WMy9zbWFydFBhZ2VzL1BsYXllcl9WM19nZW5lcmljX3BhZ2UucGhwP2NkblVybD10ZXN0JnBhcnRuZXJJZD0xMDkxJnVpQ29uZklkPXRlc3RSZWcmc2VsZWN0ZWRVaUNvbmY9MTUyMTU5MzMmZW50cnlJZD10c3RicCZzZWxlY3RlZEVudHJ5SWQ9MF90dmhnamkwMSZjb21wTHN0PSZjb21wVmVyPSZjb21wVmVycz0mbG9ncz1kZWImcGxsc3RCeUVudElkPSZwbGxzdElkPSZjbnREd25UVFM9JmNudER3bkR1cj0mZW5nMT1odG1sJmVuZzI9aHRtbCZlbmczPWh0bWwmc3RQcjE9JnN0UHIyPSZzdFByMz0mdHh0TGFuZz1kZWZhdWx0JmF1ZGlvTGFuZz1kZWZhdWx0JmFfcz0wJnN0clBvcz0mYWRUYWc9bm9BZCZhZEFmdFRpbWU9Jm51bVJlZGlyZWN0cz0mZGFpPW5vRGFpJmJ1bXBlcj1ub0J1bXAmYnVtcFBvcz1kZWZCdW1wJldNUGxhY2U9&clientTag=html5:v0.53.4",
'          "mimetype": "video/mp4",
'          "bandwidth": 1642496,
'          "width": 1280,
'          "height": 720,
'          "label": "Undefined"
'        },
'        {
'          "id": "0_lbkn1m7u261,url",
'          "url": "http://cdntesting.qa.mkaltura.com/p/1091/sp/109100/playManifest/entryId/0_tvhgji01/protocol/http/format/url/flavorIds/0_lbkn1m7u/a.mp4?uiConfId=15215933&playSessionId=ef0ba6a2-5b5d-33a0-b9f0-c8558d63cf62:22ef212a-41f7-d72b-6f65-fceeb7888a08&referrer=aHR0cDovL2V4dGVybmFsdGVzdHMuZGV2LmthbHR1cmEuY29tL3BsYXllci9saWJyYXJ5X1BsYXllcl9WMy9zbWFydFBhZ2VzL1BsYXllcl9WM19nZW5lcmljX3BhZ2UucGhwP2NkblVybD10ZXN0JnBhcnRuZXJJZD0xMDkxJnVpQ29uZklkPXRlc3RSZWcmc2VsZWN0ZWRVaUNvbmY9MTUyMTU5MzMmZW50cnlJZD10c3RicCZzZWxlY3RlZEVudHJ5SWQ9MF90dmhnamkwMSZjb21wTHN0PSZjb21wVmVyPSZjb21wVmVycz0mbG9ncz1kZWImcGxsc3RCeUVudElkPSZwbGxzdElkPSZjbnREd25UVFM9JmNudER3bkR1cj0mZW5nMT1odG1sJmVuZzI9aHRtbCZlbmczPWh0bWwmc3RQcjE9JnN0UHIyPSZzdFByMz0mdHh0TGFuZz1kZWZhdWx0JmF1ZGlvTGFuZz1kZWZhdWx0JmFfcz0wJnN0clBvcz0mYWRUYWc9bm9BZCZhZEFmdFRpbWU9Jm51bVJlZGlyZWN0cz0mZGFpPW5vRGFpJmJ1bXBlcj1ub0J1bXAmYnVtcFBvcz1kZWZCdW1wJldNUGxhY2U9&clientTag=html5:v0.53.4",
'          "mimetype": "video/mp4",
'          "bandwidth": 2381824,
'          "width": 1280,
'          "height": 720,
'          "label": "Undefined"
'        }
'      ],
      "id": "0_tvhgji01",
      "duration": 171,
      "type": "Vod",
      "dvr": false,
      "vr": invalid,
      "metadata": {
        "name": "Stephane Legar - Comme Ci Comme ça (Music Video)  סטפן לגר - קומסי קומסה",
        "description": "",
        "tags": ""
      },
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

end sub

sub getResponse()

  print "[ getResponse ]"
  m.player = m.top.findNode("player")
  arrayUtils = AssociativeArrayUtil()

  print m.provider.responseData
  print m.provider.responseData.data
  print m.provider.responseData.data.sources
  if not m.provider.responseData["hasError"]
    config = arrayUtils.mergeDeep(m.provider.responseData.data, m.config)
    m.player.callFunc("initialize", config)
    m.player.callFunc("play")
  end if

end sub
