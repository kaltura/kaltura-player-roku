sub init()
  m._playkitLib = m.top.FindNode("PlaykitLib")
  m._playkitLib.observeField("loadStatus", "_onLoadStatusChanged")
  m._providerLib = m.top.FindNode("PlaykitProviderLib")
  m._providerLib.observeField("loadStatus", "_onLoadStatusChanged")

  m._grp = m.top.FindNode("grp")
  m._lbl = m.top.FindNode("lbl")
  _setDefaultValues()
end sub

 sub _onLoadStatusChanged()
   print "loadstatus playkit " m._playkitLib.loadStatus " provider " m._providerLib.loadStatus
   if (m._playkitLib.loadStatus = "ready" and m._providerLib.loadStatus = "ready")

     m._player = CreateObject("roSGNode", "PlaykitLib:Player")

     arrayUtils = AssociativeArrayUtil()
     m._events = arrayUtils.mergeDeep(m._events, m._player.callFunc("getPlayerEvents"))

     m._provider = CreateObject("roSGNode", "PlaykitProviderLib:OTTProvider")
     m._provider.observeField("responseData", "getProviderResponse")

     m._loadedState = true
     m.top.callFunc("dispatchEvent", m._events.KALTURA_PLAYER_LOADED)

     m._grp.removeChild(m._lbl)
     m._lbl = invalid
     m.top.appendChild(m._player)
   endif
 end sub

function _attach() as object
  playerEvents = m._player.callFunc("getPlayerEvents")

  for each event in playerEvents
    m._player.callFunc("addEventListener", playerEvents[event], m.top, "dispatchEvent")
  end for
end function

function _detach() as object
  playerEvents = m._player.callFunc("getPlayerEvents")

  for each event in playerEvents
    m._player.callFunc("removeEventListeners", playerEvents[event], m.top)
  end for
end function

function _setDefaultValues()
  m._loadedState = false
  m._readyState = false
  m._events = _getEvents()
  m._isInitialized = invalid
end function

function _selectPoster(config as object,mediaConfig as object) as string
  displaySize = CreateObject("roDeviceInfo").GetDisplaySize()
  print displaySize
  if config <> invalid and config.sources <> invalid and mediaConfig <> invalid and mediaConfig.sources <> invalid
    return _getKalturaPoster(config.sources,mediaConfig.sources,displaySize)
  endif
end function

function initialize(config as object)
  print "[ initialize kaltura player ]"
  m._isInitialized = true
  print config
  print config.provider
  if config = invalid then return invalid
  m._player.callFunc("initialize", config)
  m._provider.callFunc("initialize",config.provider)
  _attach()
end function

function loaded() as boolean
  return m._loadedState
end function

function ready() as boolean
  return m._readyState
end function

function getKalturaPlayerEvents() as object
  return m._events
end function

function loadMedia(mediaInfo as object)
  reset()
  m._mediaInfo = mediaInfo
  m._provider.callFunc("getMediaConfig",m._mediaInfo)
end function

function setMedia(mediaConfig as object)
  print "[ setMedia ]"
  arrayUtils = AssociativeArrayUtil()
  playerConfig = arrayUtils.mergeDeep(mediaConfig, getMediaConfig())
  playerConfig = arrayUtils.mergeDeep(playerConfig, {"session": m._player.callFunc("getConfig").session})
  print _selectPoster(playerConfig,mediaConfig)
  config_tmp = arrayUtils.mergeDeep({"sources":{"poster": _selectPoster(playerConfig,mediaConfig)}}, mediaConfig)
  print config_tmp
  m._player.callFunc("configure", config_tmp)
  m._readyState = true
  m.top.callFunc("dispatchEvent", m._events.MEDIA_LOADED)
end function

function getMediaInfo() as object
  return m._mediaInfo
end function

function getMediaConfig() as object
  return {
    sources: m._player.callFunc("getConfig").sources
    plugins: m._player.callFunc("getConfig").plugins
  }
end function

function getPoster() as string
  if config <> invalid and config.sources <> invalid
    return config.sources.poster
  endif
end function

function reset()
  m._readyState = false
  _detach()
  m._player.callFunc("reset")
end function

function play() as void
  m._player.callFunc("play")
end function

function pause() as void
  m._player.callFunc("pause")
end function

function preload() as void
  m._player.callFunc("preload")
end function

function load(startTime=0 as integer) as void
  m._player.callFunc("load", startTime)
end function

function loop(isLoop as boolean) as void
  m._player.callFunc("loop",isLoop)
end function

function mute(isMuted as boolean) as void
  m._player.callFunc("mute",isMuted)
end function

function getAudioTracks() as object
  return m._player.callFunc("getAudioTracks")
end function

function getCurrentAudioTrack() as object
  return m._player.callFunc("getCurrentAudioTrack")
end function

function selectAudioTrack(track as object) as object
  m._player.callFunc("selectAudioTrack", track)
end function

function getTextTracks() as object
  return m._player.callFunc("getTextTracks")
end function

function getCurrentTextTrack() as object
  return m._player.callFunc("getCurrentTextTrack")
end function

function hideTextTrack() as void
  m._player.callFunc("hideTextTrack")
end function

function seekToLiveEdge() as void
  m._player.callFunc("seekToLiveEdge")
end function

function isLive() as boolean
  return m._player.callFunc("isLive")
end function

function getVideoElement() as object
  return m._player.callFunc("getVideoElement")
end function

function getCurrentTime() as integer
  return m._player.callFunc("getCurrentTime")
end function

function setCurrentTime(currentTime as integer) as void
  m._player.callFunc("setCurrentTime",currentTime)
end function

sub getProviderResponse()
  print "[ getProviderResponse ]"
  arrayUtils = AssociativeArrayUtil()

  if not m._provider.responseData["hasError"]
    config = arrayUtils.mergeDeep(m._provider.responseData["data"], m._player.callFunc("getConfig"))
    setMedia(config)
  end if
end sub