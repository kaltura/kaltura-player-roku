function _getKalturaPoster(playerSources as object, mediaSources as object, dimensions as object) as string

    playerPoster = playerSources.poster
    mediaConfigPoster = mediaSources.poster
    playerWidth = dimensions.w
    playerHeight = dimensions.h
    if ( type(playerPoster) = "String" or type(playerPoster) = "roString" ) and playerPoster = mediaConfigPoster then
        regexThumbnail = CreateObject("roRegex", "/.*\/thumbnail\/.*(?:width|height)\/\d+\/(?:height|width)\/\d+/", "i")
        if regexThumbnail.IsMatch(playerPoster)
            return _setPlayerDimensionsOnPoster(playerPoster,playerWidth,playerHeight)
        endif
    endif
    if type(playerPoster) = "roArray"
        return _selectPosterByPlayerDimensions(playerPoster,playerWidth,playerHeight)
    end if

    return ""
end function

function _setPlayerDimensionsOnPoster(poster as string, playerWidth as integer, playerHeight as integer) as string
    widthRegex = CreateObject("roRegex", "/width\/(\d+)/", "i")
    widthMatch = widthRegex.Match(poster)
    heightRegex = CreateObject("roRegex", "/height\/(\d+)/", "i")
    heightMatch = heightRegex.Match(poster)
    if type(widthMatch) = "roArray"
        returnPoster = widthRegex.replace(poster,playerWidth)
    end if
    if type(heightMatch) = "roArray"
        returnPoster = heightRegex.replace(poster,layerHeight)
    end if
    return returnPoster
end function

function _selectPosterByPlayerDimensions(posters as object, playerWidth as integer, playerHeight as integer) as string
    min = 9999999999
    url = ""
    For each poster in posters
        picWidth = poster.width
        picHeight = poster.height
        widthDelta = Abs(picWidth - playerWidth)
        heightDelta = Abs(picHeight - playerHeight)
        delta = widthDelta + heightDelta
        if delta < min
            min = delta
            url = poster.url
        end if
    End For
    return url
end function
