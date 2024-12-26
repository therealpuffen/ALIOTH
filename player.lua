Player = {}

function Player:load()
    camera = require 'libraries/camera'
    cam = camera()

    anim8 = require 'libraries/anim8'

    sti = require 'libraries/sti'
    gameMap = sti 'maps/testmap.lua'

    love.graphics.setDefaultFilter("nearest", "nearest")
    background = love.graphics.newImage('sprites/background.png')

    --Player information and sprites.
    self.x = 400
    self.y = 300
    self.speed = 115
    self.sprites = love.graphics.newImage('sprites/coin_singel.png')
    self.spritesheet = love.graphics.newImage('sprites/player-sheet2.png')
    self.grid = anim8.newGrid(64, 64, self.spritesheet:getWidth(), self.spritesheet:getHeight() )

    --Player animations.
    self.animations = {}
    self.animations.down = anim8.newAnimation( self.grid( '1-4', 1), 0.2)
    self.animations.left = anim8.newAnimation( self.grid( '1-4', 2), 0.2)
    self.animations.right = anim8.newAnimation( self.grid( '1-4', 3), 0.2)
    self.animations.up = anim8.newAnimation( self.grid( '1-4', 4), 0.2)

    self.anim = self.animations.down

end

function Player:camera()
    cam:lookAt(self.x, self.y)
    cam:zoomTo(2)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if cam.x < w/4 then
        cam.x = w/4
    end
    if cam.y < h/4 then
        cam.y = h/4
    end
    
    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    if cam.x > (mapW - w/4) then
        cam.x = (mapW - w/4)
    end
    if cam.y > (mapH - h/2) then
        cam.y = (mapH - h/2)
    end
end

function Player:update(dt)
    local isMoving = false

    if love.keyboard.isDown("right", "d") then
        self.x = self.x + self.speed * dt
        self.anim = self.animations.right
        isMoving = true
    end

    if love.keyboard.isDown("left", "a") then
        self.x = self.x - self.speed * dt
        self.anim = self.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("down", "s") then
        self.y = self.y + self.speed * dt
        self.anim = self.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("up", "w") then
        self.y = self.y - self.speed * dt
        self.anim = self.animations.up
        isMoving = true
    end
       
    if isMoving == false then
        self.anim:gotoFrame(3)
    end

    self.anim:update(dt)

    Player:camera()
end

function Player:draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["ground"])
        gameMap:drawLayer(gameMap.layers["trees"])
        self.anim:draw(self.spritesheet, self.x, self.y, nil, 0.5, nil, 32, 32)
    cam:detach()
end