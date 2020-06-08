sub init()
    m._plugins = {}
end sub

function register(pluginsName=invalid as string, pluginHandler=invalid as object) as boolean
    if pluginsName = invalid return false
    print "register"
    if not m._plugins.DoesExist(pluginsName)
        m._plugins.AddReplace(pluginsName,pluginHandler)
        print " [ PluginRegister ] - plugin " pluginName " register "
        return true
    end if
    print " [ PluginRegister ] - " pluginName " didn't success register  "
    return false
end function

function unregister(pluginsName=invalid as string) as boolean
    if pluginsName = invalid return false
    print "unregister"
    if m._plugins.DoesExist(pluginsName)
        deleteStatus = m._plugins.Delete(pluginsName)
        print " [ PluginRegister ] - " pluginName " unregister "
        return deleteStatus
    end if
    print " [ PluginRegister ] - " pluginName " doesn't exist  "
    return false
end function

function getPlugins() as object
    print "getPlugins"
    return m._plugins
end function
