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

    print config
    print config.session
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
    print conf
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
