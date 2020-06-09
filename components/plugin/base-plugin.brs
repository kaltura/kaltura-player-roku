sub init()
    _setDefaultValues()
end sub

function _setDefaultValues() as void
    m._config = {}
    m._name = ""
    m._player = {}
end function

function _initialize(name as string, player as object, config={} as object) as void
    m._name = name
    m._player = player
    m._config = config
end function

function initialize(name as string, player as object, config={} as object) as void
    _initialize(name,player,config)
end function

function isValid() as boolean
    return false
end function

function getConfig() as object
    return m._config
end function

function updateConfig(config as object) as void
    m._config = AssociativeArrayUtil().mergeDeep(config,m._config)
end function

function loadMedia(mediaInfo as object) as void
end function

function destroy() as void
end function

function reset() as void
    m._config = {}
end function

function getName() as string
    return m._name
end function

