sub init()
  print "[ kaltura player ] - init"

  m._playkitLib = createLib("PlaykitLib","pkg:/source/playkit-roku.zip")
  m._providerLib = createLib("PlaykitProviderLib","pkg:/source/playkit-roku-providers.zip")
  m._ottAnaylticsLib = createLib("PlaykitOTTAnalyticsLib","pkg:/source/playkit-roku-ott-analytics.zip",false)
  m._kavaLib = createLib("PlaykitKavaLib","pkg:/source/playkit-roku-kava.zip",false)
  m._events = _getEvents()
  m._loadedState = false
  m._isInitialized = false

  _setDefaultValues()
end sub

sub createLib(id as string, uri as string, isLoadStatusNeeded=true as boolean) as object
  lib = createObject("roSGNode", "ComponentLibrary")
  lib.id = id
  lib.uri = uri
  if isLoadStatusNeeded
    lib.observeField("loadStatus", "_onLoadStatusChanged")
  endif
  m.top.appendChild(lib)
  return lib
end sub

 sub _onLoadStatusChanged()
   print "core " m._playkitLib.loadStatus " provider " m._providerLib.loadStatus
   if (m._playkitLib.loadStatus = "ready" and m._providerLib.loadStatus = "ready")

     m._playkitLib.unobserveField("loadStatus")
     m._providerLib.unobserveField("loadStatus")

     m._player = CreateObject("roSGNode", "PlaykitLib:Player")
     m._events = AssociativeArrayUtil().mergeDeep(m._events, m._player.callFunc("getPlayerEvents"))

     m._pluginManager = CreateObject("roSGNode", "PluginManager")
     m._provider = CreateObject("roSGNode", "PlaykitProviderLib:OTTProvider")

     m._loadedState = true
     m.top.callFunc("dispatchEvent", m._events.KALTURA_PLAYER_LOADED)

     m.top.appendChild(m._player)

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
  m._pluginConfig = {}
  m._readyState = false
  m._mediaInfo = invalid
end function

function _selectPoster(config as object) as string
  displaySize = CreateObject("roDeviceInfo").GetDisplaySize()
  if config <> invalid and config.sources <> invalid
    return _getKalturaPoster(config.sources, displaySize)
  endif
  return ""
end function

function _initialize(config as object)
  print "[ initialize kaltura player ]"
  _reset()
  m._isInitialized = true
  if config = invalid then
    print "[ kaltura player ] - there isn't config object"
    return invalid
  endif
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

function _configureOrLoadPlugins(pluginConfig as object)
  if pluginConfig <> invalid
    for each key in pluginConfig.Keys()
      plugin = m._pluginManager.callFunc("get",key)
      if plugin <> invalid
        plugin.callFunc("updateConfig",pluginConfig[key])
        pluginConfig.AddReplace(key, plugin.callFunc("getConfig"))
      else
        if m._player.callFunc("getSrc") <> ""
          pluginConfig.Delete(key)
        else
          m._pluginManager.callFunc("load",key,m.top,pluginConfig[key])
        end if
      end if
    end for
  end if
  m._pluginConfig = pluginConfig
end function

function createRequestBuilder() as object
    return CreateObject("roSGNode", "PlaykitProviderLib:RequestBuilder")
end function

function getKalturaPlayerEvents() as object
  return m._events
end function

function configure(config={} as object) as void
  configWithPlugins = AssociativeArrayUtil().mergeDeep(config, _getPlayerConfig())
  configCopyForEvaluate = parseJson(formatJson(configWithPlugins))
  pluginsConfig = evaluatePluginsConfig(configCopyForEvaluate)
  _configureOrLoadPlugins(pluginsConfig)
  m._player.callFunc("configure", configWithPlugins)
end function

function loadMedia(mediaInfo as object) as void
  reset()
  m._mediaInfo = mediaInfo
  m._provider.observeField("responseData", "getProviderResponse")
  m._provider.callFunc("getMediaConfig",mediaInfo)
  m._pluginManager.callFunc("loadMedia",mediaInfo)
end function

function setMedia(mediaConfig as object) as void
  print "[ setMedia ]"
  m._readyState = false
  sources = AssociativeArrayUtil().mergeDeep(mediaConfig.sources, _getPlayerConfig().sources)
  session = AssociativeArrayUtil().mergeDeep(mediaConfig.session, _getPlayerConfig().session)
  plugins = AssociativeArrayUtil().mergeDeep(mediaConfig.plugins, _getPlayerConfig().plugins)
  playerConfig = {sources:sources, session:session, plugins:plugins}
  playerConfig = AssociativeArrayUtil().mergeDeep({"sources":{"poster": _selectPoster(playerConfig)}}, playerConfig)
  playerConfig = addKalturaParams(playerConfig)
  configure(playerConfig)
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
    sources: getConfig().sources,
    plugins: getConfig().plugins
  }
end function

function getPoster() as string
  config = _getPlayerConfig()
  if config <> invalid and config.sources <> invalid
    return config.sources.poster
  endif
  return ""
end function

function _reset()
  _setDefaultValues()
end function

function reset()
  _reset()
  m._pluginManager.callFunc("reset")
  m._player.callFunc("reset")
end function

function destroy()
  reset()
  _detach()
  m._pluginManager.callFunc("destroy")
  m._player.callFunc("destroy")
  m.top.removeChild(m._playkitLib)
  m.top.removeChild(m._providerLib)
  m.top.removeChild(m._ottAnaylticsLib)
  m.top.removeChild(m._kavaLib)
  m.top.removeChild(m._player)
  m._playkitLib = invalid
  m._player = invalid
  m._providerLib = invalid
  m._provider = invalid
  m._ottAnaylticsLib = invalid
  m._kavaLib = invalid
end function

function play() as void
  m._player.callFunc("play")
end function

function pause() as void
  m._player.callFunc("pause")
end function

function getSrc() as string
  return m._player.callFunc("getSrc")
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
  return m._player.callFunc("isMuted")
end function

function setMute(isMuted as boolean) as void
  m._player.callFunc("setMute",isMuted)
end function

function _getPlayerConfig() as object
  return AssociativeArrayUtil().mergeDeep(m._player.callFunc("getConfig"),{sources:{},plugins:{},session:{}})
end function

function getConfig() as object
  return AssociativeArrayUtil().mergeDeep(_getPlayerConfig(),{plugins:m._pluginConfig})
end function

function getAudioTracks() as object
  return m._player.callFunc("getAudioTracks")
end function

function getCurrentAudioTrack() as object
  return m._player.callFunc("getCurrentAudioTrack")
end function

function selectAudioTrack(track as object) as void
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

function getStreamType() as string
  return m._player.callFunc("getStreamType")
end function

function isDvr() as boolean
  return m._player.callFunc("isDvr")
end function

function getActiveVideoTrack() as object
  return m._player.callFunc("getActiveVideoTrack")
end function

function getDownloadedTracks() as object
  return m._player.callFunc("getDownloadedTracks")
end function

function getTimeToStartStream() as object
  return m._player.callFunc("getTimeToStartStream")
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
  if m.top.hasFocus() and m._player <> invalid
    m._player.setFocus(true)
  end if
  return false
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
