sub init()
    print "init plugin manager"
    m._activePlugins = {}
    m._disabledPlugins = {}
end sub

function load(name as string, player as object, config={} as object) as boolean
    print "[ pluginManager ] - load plugin"
    if config.name <> invalid
        componentName = config.name
    else
        libraryName = "Playkit" + name + "Lib"
        pluginNmae = name
        componentName = libraryName + ":" + pluginNmae
    end if

    pluginObj = CreateObject("roSGNode", componentName)
    if pluginObj = invalid
        print " Plugin " name " loading failed, plugin is not loaded"
        return false
    end if
    if config <> invalid and config.disable <> invalid and config.disable = true
        m._disabledPlugins.AddReplace(name)
    end if
    isDisablePlugin = m._disabledPlugins.DoesExist(name)

    if not isDisablePlugin
        if not pluginObj.callFunc("isValid")
            return false
        end if
        pluginObj.callFunc("initialize", name, player, config)
        m._activePlugins.AddReplace(name, pluginObj)
        return true
    end if

    return false
endfunction

function loadMedia(mediaInfo as object) as void
    for each key in m._activePlugins
        m._activePlugins.LookupCI(key).callFunc("loadMedia",mediaInfo)
    end for
endfunction

function destroy() as void
    for each key in m._activePlugins
        m._activePlugins.LookupCI(key).callFunc("destroy")
    end for
    m._activePlugins = invalid
endfunction

function reset() as void
    for each key in m._activePlugins
        m._activePlugins.LookupCI(key).callFunc("reset")
    end for
endfunction

function get(name as string) as object
    return m._activePlugins.LookupCI(name)
endfunction

function getAll() as object
    return m._activePlugins
endfunction
