local Vector = require('nx/vector')
local Window = require('system/window')
local Icons = require('system/icons')
local AppTemplate = require('apptemplate')
local Filesystem = require('system/filesystem')

-- NOTEPAD
local app = AppTemplate.new('TextBoy',400,500)
app.icon = 'textboy'
app.iconName = 'Textboy'

-- window == self??
function app:onStart(window,args)
    window.state.maxscrolly = 0
    if args ~= nil then
        local filename = args:split('/')[#args:split('/')]
        window.title = window.title .. ' - ' .. filename
        self.readOnly = true
        
        -- Force size change if title is too long
        if window.width < Window.OSFont:getWidth(window.title) + 256 then
            window.width = Window.OSFont:getWidth(window.title) + 256
        end

        local temp = love.filesystem.read('files/'..args)
        window.state.path = 'files/'..args
        local text,count = reloadText(window)
        window.state.maxscrolly = -count * Window.OSFont:getHeight()
        window.state.text = text
    else
        window.state.text = ''
    end

    window.state.scrolly = 0
    window.state.frame = 0
end

function reloadText(self)
    if self.state.path then
        local temp = love.filesystem.read(self.state.path)
        text,count = calcLineBreaks(temp, self.width,Window.OSFont)
        return text,count
    end
end

function app:draw(selected)
    self.state.frame = self.state.frame + 1
    love.graphics.setColor(1,1,1,1)
    local w,h = self.canvas:getDimensions()
    love.graphics.rectangle('fill', 1, 1, w-2, h-2)
    love.graphics.setColor(0,0,0,1)

    local text = self.state.text
    if math.sin(self.state.frame / 10) > 0 and selected then
        text = text .. '|'
    end
    
    love.graphics.print(text,2,2 + self.state.scrolly)

    love.graphics.setColor(0,0,0)
    local ll = self.canvas:getHeight() * self.state.scrolly / (self.state.maxscrolly )
    if ll + gScrollIncrement > self.canvas:getHeight() then
        --ll = - gScrollIncrement
    end
    love.graphics.rectangle('line', self.canvas:getWidth() - 10, ll, 10, gScrollIncrement)
end

function app:scroll(dy)
    self.state.scrolly = self.state.scrolly + dy * gScrollIncrement
    if self.state.scrolly > 0 then
        self.state.scrolly = 0
    end

    if self.state.scrolly < self.state.maxscrolly then
        self.state.scrolly = self.state.maxscrolly
    end
end

function app:textInput(text)
    local fullText = self.state.text
    fullText = fullText .. ' '
    if text ~= ' ' then
        --fullText = calcLineBreaks(self.state.text .. text,self.width,Window.OSFont)
    end
    --self.state.text = fullText
end

function app:keyPress(key)
    self.state.frame = 0
    if key == 'return' then
        self.state.text = self.state.text .. '\n'
    end

    if key == 'backspace' then
        self.state.text = self.state.text:sub(1, -2)
    end
end

function app:onResize()
    self.state.text = calcLineBreaks(reloadText(self),self.width,Window.OSFont)
end

return app