Cube = Class{}

require 'Ball'

offCubesX = {}
offCubesY = {}

function Cube:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = 0
end

function Cube:render(rows, color)

    x = VIRTUAL_WIDTH / 4 + 8
    y = 15

    local o = 0

    for row = 0, rows do
        if row % 2 == 0 or row == 0 then
            x = VIRTUAL_WIDTH / 4 + 8
        else
            x = VIRTUAL_WIDTH / 4 + 18
        end
        y = y + 10
        
        for column = 0, 9 do
            o = 0
            
            for z = 1, #offCubesX do
                if x  == offCubesX[z] and y == offCubesY[z] then
                    o = 1
                    for t = 1, #construct do
                        if construct[t].x == x and construct[t].y == y then
                            construct[t].x = VIRTUAL_WIDTH
                            break
                        end
                    end
                    
                    if o == 1 then
                        break
                    end
                end
            end
              
            if o == 0 then
                love.graphics.setColor(color)
                love.graphics.rectangle('fill', x, y, 10, 10)
            end
            x = x + 20
        end
    end
end

function Cube:getCubes(rows)
    x = VIRTUAL_WIDTH / 4 + 8
    y = 15

    i = 1

    for row = 0, rows do
        if row % 2 == 0 or row == 0 then
            x = VIRTUAL_WIDTH / 4 + 8
        else
            x = VIRTUAL_WIDTH / 4 + 18
        end
        
        y = y + 10
        
        for column = 0, 9 do
            cubes[i] = {x, y, 10, 10}

            i = i + 1
            x = x + 20
        end
    end

    local j = 1

    while #cubes >= j do
        construct[j] = Cube(cubes[j][1], cubes[j][2], cubes[j][3], cubes[j][4])

        j = j + 1
    end
end

function Cube:off()
    q = 1

    while q <= #construct do
        if ball:collides(construct[q]) then
            table.insert(offCubesX, construct[q].x)
            table.insert(offCubesY, construct[q].y)
            
            if gameState == 'Easy' then
                self:render(4, {0, 1, 0})
            elseif gameState == 'Medium' then
                self:render(6, {1, 1, 0})
            else
                self:render(8, {1, 0, 0})
            end

            break
        end

        q = q + 1
    end
end

function Cube:restart(rows1, rows2)
    for j = 1, #offCubesX do
        table.remove(offCubesX, j)
        table.remove(offCubesY, j)
    end

    cube:getCubes(rows2)
    

    x = VIRTUAL_WIDTH / 4 + 8
    y = 15

    i = 1
    local m = 1

    for row = 0, rows1 do
        if row % 2 == 0 or row == 0 then
            x = VIRTUAL_WIDTH / 4 + 8
        else
            x = VIRTUAL_WIDTH / 4 + 18
        end
        
        y = y + 10
        
        for column = 0, 9 do
            construct[m].x = x
            construct[m].y = y

            i = i + 1
            x = x + 20
            m = m + 1
        end
    end

    if gameState == 'start' then
        self:render(rows2, {0, 1, 0})
    elseif gameState == 'finish1' then
        self:render(rows2, {1, 1, 0})
    elseif gameState == 'finish2' then
        self:render(rows2, {1, 0, 0})
    end
    
end

function Cube:delete(cubes)
    for i = 51, cubes do
        construct[i].x = VIRTUAL_WIDTH
    end
end

