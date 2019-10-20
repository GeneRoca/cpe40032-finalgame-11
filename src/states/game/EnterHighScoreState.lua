EnterHighScoreState = Class{__includes = BaseState}

function EnterHighScoreState:init()

    self.transitionAlpha = 255
    self.transitionAlphas = 0

end

local chars = {

    [1] = 65,
    [2] = 65,
    [3] = 65,

}

local highlightedChar = 1

function EnterHighScoreState:enter(params)

    Timer.tween(2, {
        [self] = {transitionAlpha = 0}
    })
    :finish(function()
    end)

    self.highScores = params.highScores
    self.score = params.score
    self.scoreIndex = params.scoreIndex
    self.difficulty = params.difficulty
    self.speed = params.speed
    self.highlighted = params.highlighted

end

function EnterHighScoreState:update(dt)

    Timer.update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

        local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])

       for i = 10, self.scoreIndex, -1 do
            self.highScores[i + 1] = {
                name = self.highScores[i].name,
                score = self.highScores[i].score
            }
        end

        self.highScores[self.scoreIndex].name = name
        self.highScores[self.scoreIndex].score = self.score

        local scoresStr = ''

        for i = 1, 10 do
            scoresStr = scoresStr .. self.highScores[i].name .. '\n'
            scoresStr = scoresStr .. tostring(self.highScores[i].score) .. '\n'
        end

        love.filesystem.write('TypingGame.lst', scoresStr)

        if self.highlighted == 1 then

            Timer.tween(0.5, {
                [self] = {transitionAlphas = 255}
            }):finish(function()
            gStateMachine:change('begin', {

                difficulty = self.difficulty,
                speed = self.speed,
                highScores = self.highScores

            })
            end)
            
        else 
            Timer.tween(0.5, {
                [self] = {transitionAlphas = 255}
            }):finish(function()
            gStateMachine:change('high-scores', {
                highScores = self.highScores
            })
            end)

        end

        
    end

    if love.keyboard.wasPressed('left') and highlightedChar > 1 then
        highlightedChar = highlightedChar - 1
        gSounds['select']:play()
    elseif love.keyboard.wasPressed('right') and highlightedChar < 3 then
        highlightedChar = highlightedChar + 1
        gSounds['select']:play()
    end

    if love.keyboard.wasPressed('up') then
        chars[highlightedChar] = chars[highlightedChar] + 1
        if chars[highlightedChar] > 90 then
            chars[highlightedChar] = 65
        end
    elseif love.keyboard.wasPressed('down') then
        chars[highlightedChar] = chars[highlightedChar] - 1
        if chars[highlightedChar] < 65 then
            chars[highlightedChar] = 90
        end
    end
end

function EnterHighScoreState:render()

    love.graphics.setColor(0, 0, 0, 150)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['xs'])

    love.graphics.printf('You did great!', 0, 15, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Your score: ' .. tostring(self.score), 0, 35, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['small'])

    if highlightedChar == 1 then

        love.graphics.setColor(255, 0, 0, 255)

    end

    love.graphics.print(string.char(chars[1]), VIRTUAL_WIDTH / 2 - 40, VIRTUAL_HEIGHT / 2 - 5)
    love.graphics.setColor(255, 255, 255, 255)

    if highlightedChar == 2 then

        love.graphics.setColor(255, 0, 0, 255)

    end
    love.graphics.print(string.char(chars[2]), VIRTUAL_WIDTH / 2 - 5, VIRTUAL_HEIGHT / 2 - 5)
    love.graphics.setColor(255, 255, 255, 255)

    if highlightedChar == 3 then

        love.graphics.setColor(255, 0, 0, 255)

    end
    love.graphics.print(string.char(chars[3]), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 2 - 5)
    love.graphics.setColor(255, 255, 255, 255)

    love.graphics.setFont(gFonts['xs'])
    love.graphics.printf('Press Enter to confirm!', 0, VIRTUAL_HEIGHT - 25, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(0, 0, 0, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(0, 0, 0, self.transitionAlphas)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end