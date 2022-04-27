textutils = {}

function textutils.slowWrite(text, rate) end
function textutils.slowPrint(text, rate) end
function textutils.formatTime(time, twentyFourHour) end
function textutils.tabulate(tableOrColor1, tableOrColor2, ...) end
function textutils.pagedTabulate(tableOrColor1, tableOrColor2, ...) end
function textutils.pagedPrint(text, freeLines) end
function textutils.serialize(data) end
function textutils.unserialize(serializedData) end
function textutils.serializeJSON(data, unquoteKeys) end
function textutils.urlEncode(urlUnsafeString) end
function textutils.complete(partialName, environment) end