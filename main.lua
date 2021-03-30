WINDOW_HEIGHT = 600
WINDOW_WIDTH  = 800

GAME_TITLE = "PongClone"
P1_LABEL = "Player 1:\n"
P2_LABEL = "Player 2:\n"

-- general variables
BAR_LENGTH = 50         -- 'width' of the rectangle that represents a players bar
BAR_THICKNESS = 12      -- 'height' of the rectangle that represents a players bar
BAR_MOVE_SPEED = 300

-- variable definitions for player 1 rectangle
p1_score = 0
p1_bar_x = 10
p1_bar_y = WINDOW_HEIGHT/2 - BAR_LENGTH/2

-- variable definitions for player 2 rectangle
p2_score = 0
p2_bar_x = WINDOW_WIDTH - BAR_THICKNESS - 10
p2_bar_y = WINDOW_HEIGHT/2 - BAR_LENGTH/2

-- variable definitions for the ball
BALL_HEIGHT = 10
BALL_WIDTH  = 10
ball_x = WINDOW_WIDTH/2 - BALL_WIDTH/2
ball_y = WINDOW_HEIGHT/2 - BALL_HEIGHT/2
ball_dx = 0
ball_dy = 0

-- called one time upon start of the game
function love.load()
    love.window.setTitle(GAME_TITLE)
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {})

    spawnBall()
end

-- called on each game-loop iteration passing deltatime
function love.update(dt)
    if ball_x <= 0 then
        p2_score = p2_score + 1
        spawnBall()
    end

    if ball_x >= WINDOW_WIDTH then
        p1_score = p1_score + 1
        spawnBall()
    end
    ball_x = ball_x + ball_dx*dt
    ball_y = ball_y + ball_dy*dt

    detectBarMovement(dt)
end

-- called on each game-loop iteration after love.update to render graphics
function love.draw() 
    -- game title & labels
    love.graphics.printf(GAME_TITLE, 0, 10, WINDOW_WIDTH, 'center')
    love.graphics.printf(P1_LABEL..p1_score, 0, 10, WINDOW_WIDTH, 'left', 0, 1, 1, -20)
    love.graphics.printf(P2_LABEL..p2_score, 0, 10, WINDOW_WIDTH, 'right', 0, 1, 1, 20)

    -- player 1 bar: left screen side
    love.graphics.rectangle('fill', p1_bar_x, p1_bar_y, BAR_THICKNESS, BAR_LENGTH)

    -- player 2 bar: right screen side
    love.graphics.rectangle('fill', p2_bar_x, p2_bar_y, BAR_THICKNESS, BAR_LENGTH)

    -- ball
    love.graphics.rectangle('fill', ball_x, ball_y, BALL_WIDTH, BALL_HEIGHT)
end

-- handle keyboard input
function detectBarMovement(dt)
    if love.keyboard.isDown('w') then
        p1_bar_y = math.max(0, p1_bar_y - BAR_MOVE_SPEED*dt)
    end

    if love.keyboard.isDown('s') then
        p1_bar_y = math.min(WINDOW_HEIGHT - BAR_LENGTH, p1_bar_y + BAR_MOVE_SPEED*dt)
    end

    if love.keyboard.isDown('i') then
        p2_bar_y = math.max(0, p2_bar_y - BAR_MOVE_SPEED*dt)
    end 

    if love.keyboard.isDown('k') then
        p2_bar_y = math.min(WINDOW_HEIGHT - BAR_LENGTH, p2_bar_y + BAR_MOVE_SPEED*dt)
    end

    if love.keyboard.isDown('escape') then
        love.quit()
    end
end

function spawnBall()
    ball_x = WINDOW_WIDTH/2 - BALL_WIDTH/2
    ball_y = WINDOW_HEIGHT/2 - BALL_HEIGHT/2

    math.randomseed(os.time())

    -- initialize the dx / dy variables which determine the direction of the ball
    ball_dx = math.random(2) == 1 and 120 or -120
    ball_dy = math.random(-70, 70)
end
