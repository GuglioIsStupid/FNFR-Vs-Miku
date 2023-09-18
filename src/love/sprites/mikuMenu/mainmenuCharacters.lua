return graphics.newSprite(
	love.graphics.newImage(graphics.imagePath("mikuMenu/mainmenuCharacters")),
	-- Automatically generated from mainmenuCharacters.xml
	{
		{x = 0, y = 0, width = 1280, height = 720, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 1: credits
		{x = 0, y = 720, width = 1280, height = 720, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 2: freeplay
		{x = 0, y = 1440, width = 1280, height = 720, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 3: settings
		{x = 0, y = 2160, width = 1280, height = 720, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0} -- 4: storymode
	},
	{
		["storymode"] = {start = 4, stop = 4, speed = 24, offsetX = 0, offsetY = 0},
        ["freeplay"] = {start = 2, stop = 2, speed = 24, offsetX = 0, offsetY = 0},
        ["options"] = {start = 3, stop = 3, speed = 24, offsetX = 0, offsetY = 0},
        ["credits"] = {start = 1, stop = 1, speed = 24, offsetX = 0, offsetY = 0},
	},
	"storymode",
	true
)
