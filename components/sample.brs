sub init() as void
    m.top.setFocus(true)
    m._kalturaPlayerLib = m.top.FindNode("KalturaPlayerLib")
    m._kalturaPlayerLib.observeField("loadStatus", "_onLoadStatusChanged")
end sub

function _onLoadStatusChanged() as void
    print "[ kaltura player ] - load status " m._kalturaPlayerLib.loadStatus
    if m._kalturaPlayerLib.loadStatus = "ready"

        m._kalturaPlayerLib.unobserveField("loadStatus")
        m.config = {
            "provider": {
                "partnerId":""
                "env":{
                    "serviceUrl":""
                }
            },
            "playback": {
                "startTime": -1,
                "preload": false,
                "autoplay": false,
                "loop": false,
                "muted": false,
                "options": {
                    "rokuConfig": {
                    }
                },
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
            },
            "plugins":{
                OTTAnalytics:{
                    "serviceUrl":"",
                    "entryId": "",
                    "isAnonymous": false
                }
            }
        }

        m.kalturaPlayer = CreateObject("roSGNode", "KalturaPlayerLib:KalturaPlayer")
        m.top.appendChild(m.kalturaPlayer)
        kalturaPlayerEvent = m.kalturaPlayer.callFunc("getKalturaPlayerEvents")
        m.kalturaPlayer.callFunc("addEventListener", kalturaPlayerEvent.KALTURA_PLAYER_LOADED, m.top, "loaded")
        m.kalturaPlayer.callFunc("addEventListener", kalturaPlayerEvent.MEDIA_LOADED, m.top, "ready")
    endif
end function

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
        "entryId":""
    })
end function

function ready(event as string, payload as object)
    print "ready"
    m.kalturaPlayer.callFunc("play")
end function
