return {
    enter = function(self)
        music:stop()
        video = cutscene.video("videos/creditsend.ogv")
        video:play()

        graphics:mikuTransitionIn()
    end,

    update = function(self, dt)
        if not video:isPlaying() or input:pressed("confirm") then
            video:pause()
            Gamestate.switch(menuCredits)
            inCutscene = false
        end
    end,

    draw = function(self)
        video:draw(true)
    end,

    leave = function(self)

    end
}