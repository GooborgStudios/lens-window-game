require('nx/util')
require('nx/thirdparty')
require('nx/update')
local Apps = require('apps')
local Window = require('system/window')

gScrollIncrement = Window.OSFont:getHeight() * 5 -- is this even used anywhere?
love.audio.setVolume(0.5)
love.mouse.setVisible(false)
love.graphics.setDefaultFilter('nearest', 'nearest')
love.keyboard.setKeyRepeat(true)

function executeFile(filename,data)
    local splitOnDot = filename:split('.')
    local format = splitOnDot[#splitOnDot]

    if format == 'txt' then
        LaunchApp('textboy',filename)
    end

    if format == 'exe' then
        LaunchApp(data.app)
    end

    if format == 'll' then
        LaunchApp('shell',filename)
    end

    if data.dir then
        LaunchApp('explorer',data.dir)
    end
end

function LaunchApp(appName,args)
    print(appName,args)
    return Apps[appName]:spawn(args)
end

-- EVENTS --
-- TODO: create an "events" subfolder?
function jumpScare()
    for i,v in ipairs(Window.getAll()) do
        v.jumpScare = true
        v.fullscreen = false
        v:killUntil(math.random(30,80) / 60)
    end

    local snd = love.audio.newSource('sounds/no2.ogg','static')
    snd:setPitch(0.4)
    snd:play()

    State:persist('hasSeenJumpScare')

    Timer.new(5,function() LaunchApp('popup','You were warned') end)
end

function logIn()
    State:persist('isLoggedIn')
end

function playLoginSound()
    love.audio.newSource('sounds/login.ogg', 'static'):play()
end