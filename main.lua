local oppDirs          = {"up", "down", "left", "right"}
local prevDir          = nil
local curDir           = nil 
local playerGuess      = nil
local isCorrect        = false
local hasPlayerGuessed = false

function love.load()
    love.graphics.setDefaultFilter("nearest") -- removes blur from images
    math.randomseed(os.time())

    playerGuess = " "
    shuffle(oppDirs)
    curDir = oppDirs[1] 

    font      = love.graphics.getFont()
    yourText  = love.graphics.newText(font, "Your Turn")
    oppText   = love.graphics.newText(font, "Enemy Turn")

    oppTurnOppIdle  = love.graphics.newImage("oppTurnOppIdle.png")
    yourTurnOppIdle = love.graphics.newImage("yourTurnOppIdle.png")
    heart           = love.graphics.newImage("heart.png")
    playerFish      = love.graphics.newImage("playerFish.png")
    fishDirLeft     = love.graphics.newImage("fishDirLeft.png")
    fishDirRight    = love.graphics.newImage("fishDirRight.png")
    fishDirUp       = love.graphics.newImage("fishDirUp.png")
    fishDirDown     = love.graphics.newImage("fishDirDown.png")
end

function shuffle(array)
    local counter = #array

    while counter > 1 do
        local index = math.random(counter)
        array[counter], array[index] = array[index], array[counter]
        counter = counter - 1
    end

    return array
end

function love.keypressed(key)
    if key == "w" then
        playerGuess = "up"
        hasPlayerGuessed = true
    elseif key == "s" then
        playerGuess = "down"
        hasPlayerGuessed = true
    elseif key == "a" then
        playerGuess = "left"
        hasPlayerGuessed = true
    elseif key == "d" then
        playerGuess = "right"
        hasPlayerGuessed = true
    end
end

function checkGuessTrue()
    if playerGuess == curDir then
        table.remove(oppDirs, 1)     

        if #oppDirs > 0 then
            shuffle(oppDirs)
            curDir = oppDirs[1]
        else
            curDir = nil
        end

        isCorrect = true

        fishPosX = math.random(0, 800)
        fishPosY = math.random(0, 800)
    end
end

function love.update(dt)
    if hasPlayerGuessed then -- if player made a guess
        checkGuessTrue()

        playerGuess = nil
    end
end

function love.draw()
    --
    love.graphics.print(tostring(playerGuess), 0, 0)
    love.graphics.print(curDir, 0, 10)
    love.graphics.print(oppDirs, 0, 20)
    love.graphics.print(tostring(isCorrect), 0, 30)
    

    love.graphics.setBackgroundColor(128/255,128/255,128/255)

    -- opponent
    love.graphics.setColor(1,1,1)
    love.graphics.draw(yourTurnOppIdle, 200, 75, 0, 6, 6)

    -- player fish
    love.graphics.draw(playerFish, 300, 100, 0, 6, 6)

    -- bottom ui rectangle
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", 0, 475, 800, 125)

    -- arrow boxes
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", 400, 510, 75, 75)
    love.graphics.rectangle("line", 525, 510, 75, 75)
    love.graphics.rectangle("line", 650, 510, 75, 75)

    -- heart ui
    love.graphics.setColor(1,1,1)
    love.graphics.draw(heart, 15, 487, 0, 3, 3)

    -- text
    love.graphics.draw(yourText, 505, 477, 0, 2, 2)

    -- guessing correctly
    if isCorrect then
        if playerGuess == "up" then
            love.graphics.draw(fishDirUp, fishPosX, fishPosY, 0, 3, 3)
        elseif playerGuess == "down" then
            love.graphics.draw(fishDirDown, fishPosX, fishPosY, 0, 3, 3)
        elseif playerGuess == "left" then
            love.graphics.draw(fishDirLeft, fishPosX, fishPosY, 0, 3, 3)
        elseif playerGuess == "right" then
            love.graphics.draw(fishDirRight, fishPosX, fishPosY, 0, 3, 3)
        end     
    end
end