return {
    enter = function()
        camera.defaultZoom = 0.8
        camera.zoom = 0.8
        stageImages = {
            bg2 = graphics.newImage(graphics.imagePath("expo/nightsky")),
            bg1 = graphics.newImage(graphics.imagePath("expo/backlight")),
            bg4 = graphics.newImage(graphics.imagePath("expo/concerttop")),
            bg3 = graphics.newImage(graphics.imagePath("expo/stadiumback")),
            bg5 = graphics.newImage(graphics.imagePath("expo/speakers")),
            bg = graphics.newImage(graphics.imagePath("expo/mainstage")),

            light1 = graphics.newImage(graphics.imagePath("expo/focus_light")),
            bgblack = graphics.newImage(graphics.imagePath("blacksocool")),
        }

        stageImages.bg2.sizeX, stageImages.bg2.sizeY = 1.1, 1.1
        stageImages.bg1.sizeX, stageImages.bg1.sizeY = 1.1, 1.1
        stageImages.bg4.sizeX, stageImages.bg4.sizeY = 1.1, 1.1
        stageImages.bg3.sizeX, stageImages.bg3.sizeY = 1.1, 1.1
        stageImages.bg5.sizeX, stageImages.bg5.sizeY = 1.1, 1.1
        stageImages.bg.sizeX, stageImages.bg.sizeY = 1.1, 1.1
        stageImages.light1.sizeX, stageImages.light1.sizeY = 1.6, 1.6
        stageImages.bgblack.sizeX, stageImages.bgblack.sizeY = 1.6, 1.6

        enemy = love.filesystem.load("sprites/characters/miku.lua")()

        if girlfriend then girlfriend.x, girlfriend.y = 30, -10 end
        enemy.x, enemy.y = -325, 10
        boyfriend.x, boyfriend.y = 345, 185
    end,

    load = function()

    end,

    update = function(self, dt)
    end,

    draw = function()
        love.graphics.push()
            love.graphics.translate(camera.x * 0.6, camera.y * 0.6)
            love.graphics.translate(camera.ex * 0.6, camera.ey * 0.6)
            stageImages.bg2:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x * 0.7, camera.y * 0.7)
            love.graphics.translate(camera.ex * 0.7, camera.ey * 0.7)
            stageImages.bg1:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x * 0.75, camera.y * 0.75)
            love.graphics.translate(camera.ex * 0.75, camera.ey * 0.75)
            stageImages.bg4:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x * 0.8, camera.y * 0.8)
            love.graphics.translate(camera.ex * 0.8, camera.ey * 0.8)
            stageImages.bg3:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x * 0.9, camera.y * 0.9)
            love.graphics.translate(camera.ex * 0.9, camera.ey * 0.9)
            stageImages.bg5:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x, camera.y)
            love.graphics.translate(camera.ex, camera.ey)
            stageImages.bg:draw()
            if girlfriend then girlfriend:draw() end
            enemy:draw()
            boyfriend:draw()
        love.graphics.pop()
    end,

    leave = function()
        for i, v in pairs(stageImages) do
            v = nil
		end

        graphics.clearCache()
    end
}