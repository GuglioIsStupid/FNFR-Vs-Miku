local freeplayObj = {}
freeplayObj.__index = freeplayObj

freeplayObj.isSelected = false
freeplayObj.score = 0
freeplayObj.stars = {}

freeplayObj.group = nil

function freeplayObj:new(x, y, _song)
    local self = setmetatable({}, freeplayObj)
    self.group = Group()
    self.x = x
    self.y = y
    self.song = _song
    self.bg = Sprite(x, y)
    self.bg:setFrames(getSparrow(graphics.imagePath("mikuMenu/freeplaybricks")))
    self.bg:addAnimByPrefix("idle", "freeplay brick", 24, true)
    self.bg:addAnimByPrefix("selected", "freeplaybrick select", 24, true)
    self.bg:play("idle", true)
    self.bg:setGraphicSize(math.floor(self.bg.width * 0.8))
    self.bg:updateHitbox()
    self.group:add(self.bg)

    self.songText = {
        x=self.bg.x+120,y=self.bg.y+9,limit=1180,text=_song,size=40,
        font=funkin,color=0xFFFFFFFF,align="left",
        border="outline",borderColor=0xFF000000,borderSize=2.4,
        width = 0, height = 0,
        setup = function(self, text)
            self.text = text
            self.width = self.font:getWidth(self.text)
            --self.height = self.font:getHeight(self.text)
            -- since limit is 1180 pixels, determine the real height
            self.height = self.font:getHeight(self.text, self.limit)
            local lines = math.floor(self.width / self.limit)
            self.height = self.height * (lines+1)
        end,
        update = function(self, dt)
            self.width = self.font:getWidth(self.text)
            --self.height = self.font:getHeight(self.text)
        end,

        screenCenter = function(self, axis)
            local axis = axis or "XY"
            local width = font:getWidth(self.text)
            local height = font:getHeight(self.text)
            if axis:find("X") then
                self.x = push:getWidth()/2 - width/2
            end
            if axis:find("Y") then
                self.y = push:getHeight()/2 - height/2
            end
        end,

        draw = function(self)
            love.graphics.push()
            love.graphics.setFont(self.font)
            love.graphics.setColor(hex2rgb(self.borderColor))
            love.graphics.printf(self.text, self.x-self.borderSize/2, self.y-self.borderSize/2, self.limit, self.align)
            love.graphics.printf(self.text, self.x+self.borderSize/2, self.y-self.borderSize/2, self.limit, self.align)
            love.graphics.printf(self.text, self.x-self.borderSize/2, self.y+self.borderSize/2, self.limit, self.align)
            love.graphics.printf(self.text, self.x+self.borderSize/2, self.y+self.borderSize/2, self.limit, self.align)
            love.graphics.printf(self.text, self.x+self.borderSize/2, self.y, self.limit, self.align)
            love.graphics.printf(self.text, self.x-self.borderSize/2, self.y, self.limit, self.align)
            love.graphics.printf(self.text, self.x, self.y+self.borderSize/2, self.limit, self.align)
            love.graphics.printf(self.text, self.x, self.y-self.borderSize/2, self.limit, self.align)
            love.graphics.setColor(hex2rgb(self.color))
            love.graphics.printf(self.text, self.x, self.y, self.limit, self.align)
            love.graphics.pop()
        end
    }

    self.group:add(self.songText)

    self.scoreText = {
        x=self.songText.x,y=self.songText.y+40,limit=1180,text="",size=40,
        font=funkin,color=0xFFFFFFFF,align="left",
        border="outline",borderColor=0xFF000000,borderSize=2.4,
        width = 0, height = 0,
        setup = function(self, text)
            self.text = text
            self.width = self.font:getWidth(self.text)
            --self.height = self.font:getHeight(self.text)
            -- since limit is 1180 pixels, determine the real height
            self.height = self.font:getHeight(self.text, self.limit)
            local lines = math.floor(self.width / self.limit)
            self.height = self.height * (lines+1)
        end,
        update = function(self, dt)
            self.width = self.font:getWidth(self.text)
            --self.height = self.font:getHeight(self.text)
        end,

        screenCenter = function(self, axis)
            local axis = axis or "XY"
            local width = font:getWidth(self.text)
            local height = font:getHeight(self.text)
            if axis:find("X") then
                self.x = push:getWidth()/2 - width/2
            end
            if axis:find("Y") then
                self.y = push:getHeight()/2 - height/2
            end
        end,

        draw = function(self)
            love.graphics.push()
            love.graphics.setFont(self.font)
            love.graphics.setColor(hex2rgb(self.borderColor))
            love.graphics.printf(self.text, self.x-self.borderSize/2, self.y-self.borderSize/2, self.limit, self.align)
            love.graphics.printf(self.text, self.x+self.borderSize/2, self.y-self.borderSize/2, self.limit, self.align)
            love.graphics.printf(self.text, self.x-self.borderSize/2, self.y+self.borderSize/2, self.limit, self.align)
            love.graphics.printf(self.text, self.x+self.borderSize/2, self.y+self.borderSize/2, self.limit, self.align)
            love.graphics.printf(self.text, self.x+self.borderSize/2, self.y, self.limit, self.align)
            love.graphics.printf(self.text, self.x-self.borderSize/2, self.y, self.limit, self.align)
            love.graphics.printf(self.text, self.x, self.y+self.borderSize/2, self.limit, self.align)
            love.graphics.printf(self.text, self.x, self.y-self.borderSize/2, self.limit, self.align)
            love.graphics.setColor(hex2rgb(self.color))
            love.graphics.printf(self.text, self.x, self.y, self.limit, self.align)
            love.graphics.pop()
        end
    }

    self.group:add(self.scoreText)

    return self
end

function freeplayObj:update(dt)
    self.bg:update(dt)
    if self.isSelected then
        self.bg.offset.x = 100
        self.bg.offset.y = 80
    else
        self.bg.offset.x = 0
        self.bg.offset.y = 0
    end

    self.scoreText.text = "Highscore: " .. self.score
end

function freeplayObj:play(anim, force)
    self.bg:play(anim, force)
end

function freeplayObj:getY()
    return self.bg:getMidpointY()
end

function freeplayObj:getX()
    return self.bg:getMidpointX()
end

function freeplayObj:getSong()
    return self.song
end

function freeplayObj:draw()
    -- translate by x and y
    love.graphics.push()
    love.graphics.translate(self.bg.x, self.bg.y)
    self.group:draw()
    love.graphics.pop()
end

return freeplayObj