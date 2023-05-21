local oppDirs          = {"up", "down", "left", "right"}
local prevDir          = nil
local prevDir1         = nil
local nextDir          = nil 
local playerGuess      = nil
local isCorrect        = false 
local hasPlayerGuessed = false
local currentTurn      = "player"
local correctGuesses   = 0
local playerWins       = false
local fishPosX         = 375
local fishPosY         = 480

function love.load()
    love.window.setTitle("Fish Boxing")
    love.graphics.setDefaultFilter("nearest") -- removes blur from images
    math.randomseed(os.time())

    playerGuess = " "
    shuffle(oppDirs)
    nextDir = oppDirs[1] 

    font      = love.graphics.getFont()
    yourText  = love.graphics.newText(font, "Your Turn")
    oppText   = love.graphics.newText(font, "Opponent Turn")

    -- GRAPHICS
    oppTurnOppIdle    = love.graphics.newImage("assets/graphics/oppTurnOppIdle.png")
    yourTurnOppIdle   = love.graphics.newImage("assets/graphics/yourTurnOppIdle.png")
    heart             = love.graphics.newImage("assets/graphics/heart.png")
    playerFish        = love.graphics.newImage("assets/graphics/playerFish.png")
    oppTurnPlayerFish = love.graphics.newImage("assets/graphics/oppTurnPlayerFish.png")
    fishDirLeft       = love.graphics.newImage("assets/graphics/fishDirLeft.png")
    fishDirRight      = love.graphics.newImage("assets/graphics/fishDirRight.png")
    fishDirUp         = love.graphics.newImage("assets/graphics/fishDirUp.png")
    fishDirDown       = love.graphics.newImage("assets/graphics/fishDirDown.png")
    winScene          = love.graphics.newImage("assets/graphics/winScene.png")
    loseScene         = love.graphics.newImage("assets/graphics/loseScene.png")

    -- MUSIC
    dingyHalls      = love.audio.newSource("assets/music/dingy-halls.wav", "stream")
    stayAwake       = love.audio.newSource("assets/music/stay-awake.wav", "stream") 
    wunder          = love.audio.newSource("assets/music/wunder.wav", "stream")

    wunder:setVolume(0.5) -- 5% of original volume

    -- SOUNDS
    yourSlap        = love.audio.newSource("assets/sounds/slap.wav", "static")
    yourMiss        = love.audio.newSource("assets/sounds/miss.wav", "static")
    oppSlap         = love.audio.newSource("assets/sounds/oppSlap.wav", "static")
    oppMiss         = love.audio.newSource("assets/sounds/oppMiss.wav", "static")
    ohio            = love.audio.newSource("assets/sounds/ohio.wav", "static")

    yourSlap:setVolume(1)
    yourMiss:setVolume(1)
    oppSlap:setVolume(1)
    oppMiss:setVolume(1)
    ohio:setVolume(0.1)

    -- VIDEO
    -- jos = love.graphics.newVideo("assets/jos.ogv")
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
    -- GENERAL CONTROLS
    if key == "escape" then
        love.event.quit()
    end
    
    -- PLAYER CONTROLS
    if correctGuesses < 3 then
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
    else
        if key == "space" then
            resetValues()
            correctGuesses = 0
            hasPlayerGuessed = false
            currentTurn = "player"
        end
    end
end

function checkGuessTrue()
    if playerGuess == nextDir then
        table.remove(oppDirs, 1)     

        if #oppDirs > 0 then
            shuffle(oppDirs)
            nextDir = oppDirs[1]
        else
            nextDir = nil
        end

        if currentTurn == "player" then
            love.audio.play(yourSlap)
        elseif currentTurn == "opponent" then
            love.audio.play(oppSlap)
        end

        isCorrect = true

        correctGuesses = correctGuesses + 1

        if correctGuesses == 1 then
            prevDir = playerGuess
        end

        if correctGuesses == 2 then
            prevDir1 = playerGuess
        end

        --fishPosX = math.random(100, 700)
        --fishPosY = math.random(100, 800)
    else
        isCorrect      = false
        correctGuesses = 0
    end
end

function resetValues()
    oppDirs  = {"up", "down", "left", "right"}
    shuffle(oppDirs)
    nextDir  = oppDirs[1]
    prevDir  = nil
    prevDir1 = nil
end

function switchTurn()
    if currentTurn == "player" then
        -- initial value setting
        currentTurn = "opponent"
        resetValues()

    elseif currentTurn == "opponent" then
        -- initial value setting
        currentTurn = "player"
        resetValues()

    end

    hasPlayerGuessed = false
    isCorrect        = false
end

function love.update(dt)
   
    --[[
    if not wunder:isPlaying() then
        love.audio.play(wunder)
    end
    ]]
    
    if hasPlayerGuessed then -- if player made a guess
        checkGuessTrue()

        hasPlayerGuessed = false -- I FORGOT THIS AND NOW THE TURN SYSTEM WORKS

        if currentTurn == "player" then
            love.audio.play(yourMiss)
        elseif currentTurn == "opponent" then
            love.audio.play(oppMiss)
        end

        if not isCorrect then
            switchTurn()
        end

        if correctGuesses >= 3 then
            -- something
            resetValues()
            hasPlayerGuessed = false
            playerWins = true
        end
    end
end

function love.draw()
    --[[
    love.graphics.print("PLAYER GUESS: " .. tostring(playerGuess), 0, 0)
    love.graphics.print("PREVIOUS DIRECTION: " .. tostring(prevDir), 0 , 10)
    love.graphics.print("NEXT DIRECTION: " .. nextDir, 0, 20)
    love.graphics.print("DIRECTIONS: " .. table.concat(oppDirs), 0, 30)
    love.graphics.print("IS CORRECT?: " .. tostring(isCorrect), 0, 40)
    love.graphics.print("WHO'S TURN IS IT?: " .. currentTurn, 0, 50)
    love.graphics.print("HAS THE MF GUESS?: " .. tostring(hasPlayerGuessed), 0, 60)
    love.graphics.print("CORRECT GUESSES: " .. correctGuesses, 0, 70)
    love.graphics.print("PREVIOUS DIRECTION 1: " .. tostring(prevDir1), 0, 80)
    ]]

    love.graphics.setBackgroundColor(128/255,128/255,128/255)

    -- opponent
    love.graphics.setColor(1,1,1)
    love.graphics.draw(yourTurnOppIdle, 200, 75, 0, 6, 6)

    -- bottom ui rectangle
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", 0, 475, 800, 125)

    -- arrow boxes 125 apart
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", 225, 510, 75, 75)
    love.graphics.rectangle("line", 350, 510, 75, 75)
    love.graphics.rectangle("line", 475, 510, 75, 75)

    --[[
    love.graphics.setColor(1,1,1)
    love.graphics.draw(heart, 15, 487, 0, 3, 3)
    ]]

    -- guessing correctly
    if correctGuesses >= 1 then
        if prevDir == "up" then
            love.graphics.draw(fishDirUp, 200, fishPosY, 0, 2, 2)
        elseif prevDir == "down" then
            love.graphics.draw(fishDirDown, 200, fishPosY, 0, 2, 2)
        elseif prevDir == "left" then
            love.graphics.draw(fishDirLeft, 200, fishPosY, 0, 2, 2)
        elseif prevDir == "right" then
            love.graphics.draw(fishDirRight, 200, fishPosY, 0, 2, 2)
        end     
    end

    if correctGuesses == 2 then
        if prevDir1 == "up" then
            love.graphics.draw(fishDirUp, 325, fishPosY, 0, 2, 2)
        elseif prevDir1 == "down" then
            love.graphics.draw(fishDirDown, 325, fishPosY, 0, 2, 2)
        elseif prevDir1 == "left" then
            love.graphics.draw(fishDirLeft, 325, fishPosY, 0, 2, 2)
        elseif prevDir1 == "right" then
            love.graphics.draw(fishDirRight, 325, fishPosY, 0, 2, 2)
        end     
    end

    -- drawing for turn system
    if currentTurn == "opponent" then
        love.graphics.draw(oppText, 305, 477, 0, 2, 2)
        love.graphics.draw(oppTurnOppIdle, 200, 75, 0, 6, 6)
        love.graphics.draw(oppTurnPlayerFish, 300, 91, 0, 6, 6)
    elseif currentTurn == "player" then
        love.graphics.draw(yourText, 330, 477, 0, 2, 2)
        love.graphics.draw(playerFish, 300, 91, 0, 6, 6)
    end

    -- win/lose scene
    if correctGuesses >= 3 and currentTurn == "player" then
        love.graphics.draw(winScene, 0, 0)
        love.audio.stop(wunder)

        --[[ MEME WIN SCENE
        love.graphics.draw(jos, 0, 0, 0, 0.5, 0.5)
        jos:play()]]
        love.audio.play(ohio)
        
    elseif correctGuesses >= 3 and currentTurn == "opponent" then
        love.graphics.draw(loseScene, 0, 0)
    else
        love.audio.stop(ohio)
    end
end