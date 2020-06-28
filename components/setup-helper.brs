function evaluatePluginsConfig(config as object) as object

    defaultConfig = {
        ottAnalytics: {
            entryId: invalid,
            ks: invalid,
            isAnonymous: invalid,
            partnerId: invalid,
            serviceUrl: invalid
        },
        kava: {
            playerVersion: invalid,
            playerName: invalid,
            partnerId: invalid,
            playlistId: invalid,
            entryId: invalid,
            entryType: invalid,
            sessionId: invalid,
            ks: invalid,
            uiConfId: invalid,
            referrer: invalid,
            encodedReferrer: invalid
        }
    }

    commonConfig = _fetchDataFromConfig(config)
    pluginsConfig = {}
    for each plugin in defaultConfig.Items()
        pluginConfig = {}
        pluginProps = plugin.value
        for each prop in pluginProps.Items()
            if commonConfig[prop.key] <> invalid
                pluginConfig.AddReplace(prop.key, commonConfig[prop.key])
            endif
        end for
        pluginsConfig[plugin.key] = pluginConfig
    end for
    conf = AssociativeArrayUtil().mergeDeep(config.plugins,pluginsConfig)
    return conf
end function

function _fetchDataFromConfig(config as object) as object
    model = {}
    if config <> invalid

        if config.provider <> invalid
            if config.provider.env <> invalid
                model["serviceUrl"] = config.provider.env.serviceUrl
                if model["serviceUrl"] <> invalid
                    model["embedBaseUrl"] = model["serviceUrl"].Replace("api_v3/","")
                endif
            endif
            AssociativeArrayUtil().mergeDeep(model,{
                ks: config.provider.ks,
                uiConfId: config.provider.uiConfId,
                partnerId: config.provider.partnerId })
        endif

        if config.session <> invalid
            AssociativeArrayUtil().mergeDeep(model,{
                sessionId: config.session.id,
                ks: config.session.ks,
                isAnonymous: config.session.isAnonymous,
                uiConfId: config.session.uiConfId,
                partnerId: config.session.partnerId })
        end if

        if config.sources <> invalid
            entryName = invalid
            if config.sources.metadata <> invalid and config.sources.metadata.name <> invalid
                entryName = config.sources.metadata.name
            endif
            AssociativeArrayUtil().mergeDeep(model,{
                entryId: config.sources.id,
                entryName: entryName,
                entryType: config.sources.type })
        end if

    end if

    return model

end function

function handleSessionId(config as object) as object
    if config.session <> invalid and config.session.id <> invalid
        return updateSessionId(config)
    else
        return addSessionID(config)
    end if
end function

function updateSessionId(config as object) as object
    r = CreateObject("roRegex", "/:((?:[a-z0-9]|-)*)/", "i")
    secondGuid = r.MatchAll(config.session.id)
    if secondGuid <> invalid and secondGuid[1] <> invalid
        return setSessionID(config, r.Replace(config.session.id,":" + CreateObject("roDeviceInfo").GetRandomUUID()))
    end if
    return config
end function

function addSessionID(config as object) as object
    primaryGuid = CreateObject("roDeviceInfo").GetRandomUUID()
    secondGuid = CreateObject("roDeviceInfo").GetRandomUUID()
    setSessionID(config, primaryGuid + ":" + secondGuid)
end function

function setSessionID(config, sessionId) as object
    if config.session = invalid
        config.session = {}
    end if
    config.session.id = sessionId
    return config
end function
