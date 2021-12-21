Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = 0
end

function Paddle:update(dt)
    if self.dx < 0 then
        self.x = math.max(VIRTUAL_WIDTH / 4 + 1, self.x + self.dx * dt)
    elseif self.dx > 0 then
        self.x = math.min(VIRTUAL_WIDTH / 4 * 3 - 31, self.x + PADDLE_SPEED * dt)
    end
end

function Paddle:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end