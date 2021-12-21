Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = -150
end

function Ball:reset(speed)
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT - 30

    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = -speed
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:collides(box)
    if self.x > box.x + box.width or self.x + self.width < box.x then
        return false
    elseif self.y + self.height < box.y or self.y > box.y + box.height then
        return false
    else
        top = math.abs(box.y - (self.y + (self.height / 2)))
        bottom = math.abs(box.y + box.height - (self.y + (self.height / 2)))
        left = math.abs(box.x - (self.x + (self.width / 2)))
        right = math.abs(box.x + box.width - (self.x + (self.width / 2)))

        side = math.min(top, bottom, left, right)

        return true
    end
end

function Ball:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end