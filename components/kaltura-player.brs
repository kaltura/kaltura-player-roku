sub init()
  m._playkitLib = m.top.FindNode("PlaykitLib")
  m._playkitLib.observeField("loadStatus", "_onLoadStatusChanged")
  m._providerLib = m.top.FindNode("PlaykitProviderLib")
  m._providerLib.observeField("loadStatus", "_onLoadStatusChanged")

  _setDefaultValues()
end sub

 sub _onLoadStatusChanged()
   print "loadstatus playkit " m._playkitLib.loadStatus " provider " m._providerLib.loadStatus
   if (m._playkitLib.loadStatus = "ready" and m._providerLib.loadStatus = "ready")

     m._playkitLib.unobserveField("loadStatus")
     m._providerLib.unobserveField("loadStatus")

     m._player = CreateObject("roSGNode", "PlaykitLib:Player")
     m._events = AssociativeArrayUtil().mergeDeep(m._events, m._player.callFunc("getPlayerEvents"))
     m._provider = CreateObject("roSGNode", "PlaykitProviderLib:OTTProvider")

     m._loadedState = true
     m.top.callFunc("dispatchEvent", m._events.KALTURA_PLAYER_LOADED)

     m.top.appendChild(m._player)
     m._player.setFocus(true)

   endif
 end sub

function _sourceSelectedListener(event as string, payload as object) as void
  m._readyState = true
  m.top.callFunc("dispatchEvent", m._events.MEDIA_LOADED)
end function

function _attach() as object
  playerEvents = m._player.callFunc("getPlayerEvents")

  for each event in playerEvents
    m._player.callFunc("addEventListener", playerEvents[event], m.top, "dispatchEvent")
  end for

  m._player.callFunc("addEventListener", playerEvents.SOURCE_SELECTED, m.top, "_sourceSelectedListener")
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
  m._mediaInfo = invalid
end function

function _selectPoster(config as object,mediaConfig as object) as string
  displaySize = CreateObject("roDeviceInfo").GetDisplaySize()
  if config <> invalid and config.sources <> invalid and mediaConfig <> invalid and mediaConfig.sources <> invalid
    return _getKalturaPoster(config.sources,mediaConfig.sources,displaySize)
  endif
  return ""
end function

function _initialize(config as object)
  print "[ initialize kaltura player ]"
  m._isInitialized = true
  if config = invalid then return invalid
  m._player.callFunc("initialize", config)
  m._provider.callFunc("initialize",config.provider)
  _attach()
end function

function setup(config as object)
  _initialize(config)
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

function loadMedia(mediaInfo as object) as void
  m._mediaInfo = mediaInfo
  m._provider.observeField("responseData", "getProviderResponse")
  m._provider.callFunc("getMediaConfig",m._mediaInfo)
end function

function setMedia(mediaConfig as object) as void
  print "[ setMedia ]"
  playerConfig = AssociativeArrayUtil().mergeDeep(mediaConfig, m._player.callFunc("getConfig"))
  config_tmp = AssociativeArrayUtil().mergeDeep({"sources":{"poster": _selectPoster(m._player.callFunc("getConfig"), mediaConfig)}}, mediaConfig)
  m._player.callFunc("configure", config_tmp)
end function

function getDuration() as integer
  return m._player.callFunc("getDuration")
end function

function getMediaInfo() as object
  if m._mediaInfo <> invalid
    return m._mediaInfo
  else
    return {}
  end if
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
  m._player.callFunc("reset")
  _setDefaultValues()
  _detach()
end function

function destroy()
  m._player.callFunc("destroy")
  reset()
  m.top.removeChild(m._playkitLib)
  m.top.removeChild(m._providerLib)
  m.top.removeChild(m._player)
  m._playkitLib = invalid
  m._providerLib = invalid
  m._player = invalid
  m._provider = invalid
end function

function play() as void
  m._player.callFunc("play")
end function

function pause() as void
  m._player.callFunc("pause")
end function

function setPreload() as void
  m._player.callFunc("setPreload")
end function

function load(startTime=0 as integer) as void
  m._player.callFunc("load", startTime)
end function

function setLoop(isLoop as boolean) as void
  m._player.callFunc("setLoop",isLoop)
end function

function isMuted() as boolean
  m._player.callFunc("isMuted")
end function

function setMute(isMuted as boolean) as void
  m._player.callFunc("setMute",isMuted)
end function

function getConfig() as object
  return m._player.callFunc("getConfig")
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

function selectTextTrack(track as object) as void
  m._player.callFunc("selectTextTrack", track)
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

function getHeight() as integer
  return m._player.callFunc("getHeight")
end function

function setHeight(height as integer) as void
  m._player.callFunc("setHeight",height)
end function

function getWidth() as integer
  return m._player.callFunc("getWidth")
end function

function setWidth(width as integer) as void
  m._player.callFunc("setWidth",width)
end function

sub getProviderResponse()
  print "[ getProviderResponse ]"
  m._provider.unobserveField("responseData")

  if not m._provider.responseData["hasError"]
    setMedia(m._provider.responseData["data"])
  else
    m.top.callFunc("dispatchEvent", m._events.ERROR, m._provider.responseData["data"])
  end if
end sub
