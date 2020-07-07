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
            playerVersion: getClientTag(),
            playerName: invalid,
            partnerId: invalid,
            playlistId: invalid,
            entryId: invalid,
            entryType: invalid,
            sessionId: invalid,
            ks: invalid,
            uiConfId: invalid,
            referrer: getReferrer(),
            encodedReferrer: invalid
        }
    }

    commonConfig = _fetchDataFromConfig(config)
    pluginsConfig = {}
    for each plugin in defaultConfig.Items()
        pluginConfig = {}
        pluginProps = plugin.value
        for each prop in pluginProps.Items()
            if pluginProps[prop.key] <> invalid
                pluginConfig.AddReplace(prop.key, pluginProps[prop.key])
            elseif commonConfig[prop.key] <> invalid
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
    return setSessionID(config, primaryGuid + ":" + secondGuid)
end function

function setSessionID(config as object, sessionId as string) as object
    if config.session = invalid
        config.session = {}
    end if
    config.session.id = sessionId
    return config
end function

function getReferrer() as string
    channelId = CreateObject("roAppInfo").GetID()
    ba=CreateObject("roByteArray")
    ba.FromAsciiString(channelId)
    return ba.ToBase64String()
end function

function addReferrer(url as string, paramName="referrer=" as string) as string
    if StringUtil().indexOf(url,paramName) = -1
        url += getQueryStringParamDelimiter(url) + paramName + getReferrer()
    end if
    return url
end function

function addUIConfId(url as string, config as object ,paramName="uiConfId=" as string) as string
    uiconfid = invalid
    if config.provider <> invalid and config.provider.uiConfId <> invalid then uiconfid = config.provider.uiConfId
    if StringUtil().indexOf(url,paramName) = -1 and uiconfid <> invalid
        url += getQueryStringParamDelimiter(url) + paramName + uiconfid
    end if
    return url
end function

function getClientTag() as string
    return CreateObject("roAppInfo").GetVersion()
end function

function addClientTag(url as string,paramName="clientTag=roku:v" as string) as string
    if StringUtil().indexOf(url,paramName) = -1
        url += getQueryStringParamDelimiter(url) + paramName + getClientTag()
    end if
    return url
end function

function updateSessionIdInUrl(url as string, sessionId as string, paramName="playSessionId=" as string ) as string
    if sessionId <> invalid
        r = CreateObject("roRegex", paramName + "((?:[a-z0-9]|-)*:(?:[a-z0-9]|-)*)", "i")
        sessionIdInUrl = r.MatchAll(url)
        if sessionIdInUrl <> invalid and sessionIdInUrl[1] <> invalid
            url = r.Replace(paramName+sessionId)
        else
            url += getQueryStringParamDelimiter(url) + paramName + sessionId
        end if
    end if
    return url
end function

function getQueryStringParamDelimiter(url as string) as string
    if StringUtil().indexOf(url,"?") = -1
        return "?"
     else
        return "&"
    end if
end function

function addKalturaParams(config as object) as object
    PLAY_MANIFEST = "playmanifest/"
    DRM_SESSION_ID = "sessionId="
    UDRM_DOMAIN = "kaltura.com"
    CUSTOM_DATA = "custom_data="
    SIGNATURE = "signature="
    config = handleSessionId(config)
    _sessionId = config.session.id
    _streamsType = getStreamsType()
    for i=0 to _streamsType.count() - 1
        sourcesFormat = config.sources.LookupCI(_streamsType[i])
        if sourcesFormat <> invalid
            for j=0 to sourcesFormat.count() - 1
                source = sourcesFormat[j]
                if StringUtil().isString(source.url) and StringUtil().indexOf(source.url,PLAY_MANIFEST) > -1
                    source.url = updateSessionIdInUrl(source.url, _sessionId)
                    source.url = addReferrer(source.url)
                    source.url = addClientTag(source.url)
                end if
                if source.drmData <> invalid
                    drmData = source.drmData
                    for k=0 to drmData.count() - 1
                        if StringUtil().isString(drmData[k].licenseUrl) and StringUtil().contains(drmData[k].licenseUrl,UDRM_DOMAIN) and StringUtil().contains(drmData[k].licenseUrl,CUSTOM_DATA) and StringUtil().contains(drmData[k].licenseUrl,SIGNATURE)
                            drmData[k].licenseUrl = updateSessionIdInUrl(drmData[k].licenseUrl, _sessionId, DRM_SESSION_ID)
                            drmData[k].licenseUrl = addClientTag(drmData[k].licenseUrl)
                            drmData[k].licenseUrl = addReferrer(drmData[k].licenseUrl)
                            drmData[k].licenseUrl = addUIConfId(drmData[k].licenseUrl, playerConfig)
                        end if
                        source.drmData[k] = drmData[k]
                    end for
                end if
                sourcesFormat[j] = source
            end for
        end if
        config.sources.AddReplace(_streamsType[i],sourcesFormat)
    end for
    return config
end function

function getStreamsType() as object
    return ["hls","dash","progressive"]
end function