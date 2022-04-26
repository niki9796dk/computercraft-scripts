os = {}

function os.version() end
function os.getComputerID() end
function os.getComputerLabel() end
function os.setComputerLabel(label) end
function os.run(environment, programPath, ...) end
function os.loadAPI(path) end
function os.unloadAPI(name) end
function os.pullEvent(targetEvent) end
function os.queueEvent(event, param1, param2, ...) end
function os.clock(event, param1, param2, ...) end
function os.startTimer(timeout) end
function os.cancelTimer(timerID) end
function os.time() end
function os.sleep(time) end
function os.day() end
function os.setAlarm(time) end
function os.cancelAlarm(alarmID) end
function os.shutdown() end
function os.reboot() end