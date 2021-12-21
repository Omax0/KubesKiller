WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'
require 'Cube'

function love.load()
    love.window.setTitle('MyGame')

    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    normalFont = love.graphics.newFont('04B_03__.ttf', 16)
    smallFont = love.graphics.newFont('04B_03__.ttf', 8)
    hugeFont = love.graphics.newFont('04B_03__.ttf', 24)

    gameState = 'start'

    sounds = {
        ['reflect'] = love.audio.newSource('sounds/reflect.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['paddle'] = love.audio.newSource('sounds/paddle.wav', 'static'),
        ['end'] = love.audio.newSource('sounds/end.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static')
    }

    paddle = Paddle(VIRTUAL_WIDTH / 2 - 15, VIRTUAL_HEIGHT - 15, 900, 5)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT - 20, 4, 4)

    cubes = {}

    construct = {}

    off = false

    score = 0

    cube = Cube(VIRTUAL_WIDTH / 4 + 8, 20, 10, 10)

    cube:getCubes(4)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == "enter" or key == "return" then
        if gameState == 'start' then
            gameState = 'Easy'
        elseif gameState == 'Easy' or gameState == 'Medium' or gameState == 'Hard' or gameState == 'end' or gameState == 'victory' then
            gameState = 'start'
        elseif gameState == 'finish1' then
            gameState = 'Medium'
        elseif gameState == 'finish2' then
            gameState = 'Hard'
        end
    end
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if gameState == 'Easy' or gameState == 'Medium' or gameState == 'Hard' then

        if ball.y > VIRTUAL_HEIGHT - 12 then
            sounds['end']:play()
            ball.y = VIRTUAL_HEIGHT
            gameState = 'end'
        end
        
        paddle:update(dt)
        ball:update(dt)

        -- control of paddle
        if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
            paddle.dx = -PADDLE_SPEED
        elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
            paddle.dx = PADDLE_SPEED
        else
            paddle.dx = 0
        end

        -- reflect from paddle
        if ball:collides(paddle) then
            sounds['paddle']:play()
            ball.dy = -ball.dy * 1.005
            ball.y = paddle.y - ball.height

            ball.dx = 10 * (ball.x - paddle.x - 15)
        end

        k = 1

        while #construct >= k do
            if ball:collides(construct[k]) then
                sounds['score']:play()
                
                if gameState == 'Easy' then
                    score = score + 10
                elseif gameState == 'Medium' then
                    score = score + 20
                else
                    score = score + 40
                end

                if side == top then
                    ball.dy = -ball.dy
                elseif side == bottom then
                    ball.dy = -ball.dy
                elseif side == left then
                    ball.dx = -ball.dx
                elseif side == right then
                    ball.dx = -ball.dx
                end

                off = true
            end

            k = k + 1
        end

        -- reflect to left
        if ball.x >= VIRTUAL_WIDTH / 4 * 3 - 5 then
            sounds['reflect']:play()
            ball.dx = -ball.dx
            ball.x = VIRTUAL_WIDTH / 4 * 3 - 5
        end

        -- reflect to right
        if ball.x <= VIRTUAL_WIDTH / 4 + 1 then
            sounds['reflect']:play()
            ball.dx = -ball.dx
            ball.x = VIRTUAL_WIDTH / 4 + 1
        end

        -- reflect to bottom
        if ball.y <= 6 then
            sounds['reflect']:play()
            ball.dy = -ball.dy
            ball.y = 6
        end

        if #offCubesX == 50 and gameState == 'Easy' then
            gameState = 'finish1'
            ball:reset(180)
            paddle.x = VIRTUAL_WIDTH / 2 - 15
        elseif #offCubesX == 70 and gameState == 'Medium' then
            gameState = 'finish2'
            ball:reset(200)
            paddle.x = VIRTUAL_WIDTH / 2 - 15
        elseif #offCubesX == 90 and gameState == 'Hard'then
            gameState = 'victory'
        end
    end

    if gameState == 'start' then
        ball:reset(150)
        paddle.x = VIRTUAL_WIDTH / 2 - 15
    end
end



function love.draw()
    push:apply('start')

    love.graphics.clear(0, 0, 0.2, 1)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', VIRTUAL_WIDTH / 4, 5, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT - 10)
    
    love.graphics.setColor(0, 0, 0.3, 1)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 4 + 1, VIRTUAL_HEIGHT - 15, VIRTUAL_WIDTH / 4 * 2 - 2, 5)

    if gameState == 'start' then
        score = 0
        love.graphics.setFont(normalFont)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf('Hello MyGame!', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter for play', 0,  VIRTUAL_HEIGHT / 2 + 20, VIRTUAL_WIDTH, 'center')
        
        cube:restart(4, 4)
        
        if #construct >= 70 and #construct < 90 then
            cube:delete(70)
        elseif #construct >= 90 then
            cube:delete(90)
        end

    elseif gameState == 'Easy' then
        love.graphics.setFont(normalFont)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(gameState, 0, 50, VIRTUAL_WIDTH / 4, 'center')
        love.graphics.printf(score, VIRTUAL_WIDTH / 4 * 3, 50, VIRTUAL_WIDTH / 4, 'center')
        cube:render(4, {0, 1, 0})
    elseif gameState == 'finish1' then
        sounds['victory']:play()
        love.graphics.setFont(normalFont)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf('Level Medium', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter for play', 0,  VIRTUAL_HEIGHT / 2 + 20, VIRTUAL_WIDTH, 'center')
        cube:restart(4, 6)
    elseif gameState == 'Medium' then
        love.graphics.setFont(normalFont)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(gameState, 0, 50, VIRTUAL_WIDTH / 4, 'center')
        love.graphics.printf(score, VIRTUAL_WIDTH / 4 * 3, 50, VIRTUAL_WIDTH / 4, 'center')
        cube:render(6, {1, 1, 0})
    elseif gameState == 'finish2' then
        sounds['victory']:play()
        love.graphics.setFont(normalFont)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf('Level Hard', 0, VIRTUAL_HEIGHT / 2 + 6, VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter for play', 0,  VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center')
        cube:restart(6, 8)
    elseif gameState == 'Hard' then
        love.graphics.setFont(normalFont)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(gameState, 0, 50, VIRTUAL_WIDTH / 4, 'center')
        love.graphics.printf(score, VIRTUAL_WIDTH / 4 * 3, 50, VIRTUAL_WIDTH / 4, 'center')
        cube:render(8, {1, 0, 0})
    elseif gameState == 'victory' then
        sounds['victory']:play()
        love.graphics.clear(0, 0, 0.2, 1)
        love.graphics.setFont(hugeFont)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf('Congratulations, you won!', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')
        
        love.graphics.setFont(smallFont)
        love.graphics.printf('You can play one more time. Press Enter for restart', 0,  VIRTUAL_HEIGHT / 2 + 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'end' then
        love.graphics.clear(0, 0, 0.2, 1)
        love.graphics.setFont(hugeFont)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 24, VIRTUAL_WIDTH, 'center')
        
        love.graphics.setFont(smallFont)
        love.graphics.printf('Your score: ' .. score, 0, VIRTUAL_HEIGHT / 2 + 5, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter for restart', 0,  VIRTUAL_HEIGHT / 2 + 25, VIRTUAL_WIDTH, 'center')
    end

    if off then
        cube:off()
    end

    if gameState ~= 'end' and gameState ~= 'victory' then
        paddle:render()
        ball:render()
    end

    push:apply('end')
end