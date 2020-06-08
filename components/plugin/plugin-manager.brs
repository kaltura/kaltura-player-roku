sub init()
    print "init plugin manager"
    m._activePlugins = {}
    m._disabledPlugins = {}
end sub

function load(name as string, player as object, config={} as Object) as boolean
    print "[ pluginManager ] - load plugin"
    plugins = m.global.pluginRegister.callFunc("getPlugins")
    print plugins
    if not plugins.DoesExist(name)
        print " Plugin " name " loading failed, plugin is not registered "
        return false
    end if
    plugin = plugins.LookupCI(name)
    if config <> invalid and config.disable <> invalid and config.disable = true
        m._disabledPlugins.AddReplace(name)
    end if
    isDisablePlugin = m._disabledPlugins.DoesExist(name)

    if not isDisablePlugin
        pluginObj = CreateObject("roSGNode", plugin)
        pluginObj.callFunc("initialize",name, player, config)
        m._activePlugins[name] = pluginObj
        if pluginObj.callFunc("isValid")
            isValidPlugin = pluginObj.callFunc("isValid")
        else
            m._activePlugins[name] = invalid
            return false
        end if
        return true
    end if

    return false
endfunction

function loadMedia() as void
    for each key in m._activePlugins
        m._activePlugins.LookupCI(key).callFunc(loadMedia)
    end for
endfunction

function destroy() as void
    for each key in m._activePlugins
        m._activePlugins.LookupCI(key).callFunc(destroy)
    end for
    m._activePlugins = invalid
endfunction

function reset() as void
    for each key in m._activePlugins
        m._activePlugins.LookupCI(key).callFunc(reset)
    end for
endfunction


function get(name as string) as object
    print "get"
    return m._activePlugins.LookupCI(name)
endfunction

function getAll() as object
    return m._activePlugins
endfunction
