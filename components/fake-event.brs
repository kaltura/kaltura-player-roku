sub init()
    m.top.cId = CreateObject("roDeviceInfo").GetRandomUUID()
    m.listeners = []
end sub


Function addEventListener(eventType as String, element as Object, functionName as String) as void

    listener = {
        "eventType": eventType,
        "element": element,
        "function": functionName
    }
    m.listeners.push(listener)

end Function

function removeEventListener(eventType as string, element as object) as void

    listeners = []
    for i = 0 to m.listeners.count() - 1
        if m.listeners[i]["element"].cId <> element.cId or m.listeners[i]["eventType"] <> eventType then
            listeners.push(m.listeners[i])
        end if
    end for
    m.listeners = listeners

end function

function removeEventListeners(eventType as string) as void

    listeners = []
    for i = 0 to m.listeners.count() - 1
        if m.listeners[i]["eventType"] <> eventType then
            listeners.push(m.listeners[i])
        end if
    end for
    m.listeners = listeners

end function

function dispatchEvent(eventType as string, payload=invalid as object) as void

    for i = 0 to m.listeners.count() - 1
        if m.listeners[i]["eventType"] = eventType then
            m.listeners[i]["element"].callFunc(m.listeners[i]["function"],eventType, payload)
        end if
    end for

end function
