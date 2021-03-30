WINDOW_HEIGHT = 600
WINDOW_WIDTH  = 800

GAME_TITLE = "PongClone"
P1_LABEL = "Player 1:\n"
P2_LABEL = "Player 2:\n"
winning_player = ""

-- general variables
BAR_LENGTH = 50         -- 'width' of the rectangle that represents a players bar
BAR_THICKNESS = 12      -- 'height' of the rectangle that represents a players bar
BAR_MOVE_SPEED = 300
VICTORY_THRESHOLD = 3

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
BALL_SPEEDUP = 1.1 -- 10% speedup on each collision with a bar
ball_x = WINDOW_WIDTH/2 - BALL_WIDTH/2
ball_y = WINDOW_HEIGHT/2 - BALL_HEIGHT/2
ball_dx, ball_dy = 0

game_state = "titlescreen"

-- called one time upon start of the game
function love.load()
    love.window.setTitle(GAME_TITLE)
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {})

    initGame()
end

-- called on each game-loop iteration passing deltatime
function love.update(dt)

    -- player 1 has won
    if p1_score >= VICTORY_THRESHOLD then
        victory("Player 1")
    end

    -- player 2 has won
    if p2_score >= VICTORY_THRESHOLD then
        victory("Player 2")
    end

    -- player 2 has won

    if game_state == "playing" then
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
        handleBarCollision()
        handleScreenEdgeCollision()
    end

end

-- called on each game-loop iteration after love.update to render graphics
function love.draw() 

    -- display menu when the game is started
    if game_state == "titlescreen" then
        love.graphics.printf("Press <SPACE> to start", 0, WINDOW_HEIGHT/2 - 100, WINDOW_WIDTH, 'center')
        love.graphics.printf("Player 1: up <w>, down <s>", 0, WINDOW_HEIGHT/2 - 60, WINDOW_WIDTH, 'center')
        love.graphics.printf("Player 2: up <i>, down <k>", 0, WINDOW_HEIGHT/2 - 80, WINDOW_WIDTH, 'center')

    end

    -- display victory message if a victory has been achieved
    if game_state == "victory" then 
        love.graphics.printf(winning_player .. " has won!", 0, WINDOW_HEIGHT/2 - 100, WINDOW_WIDTH, 'center')
        love.graphics.printf("Press <SPACE> to start a new game.", 0, WINDOW_HEIGHT/2 - 80, WINDOW_WIDTH, 'center')
    end

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

-- handle keypresses in menus
function love.keypressed(key)
    if (game_state == "titlescreen" or game_state == "victory") and key == "space" then
        initGame()
        spawnBall()
        game_state = "playing"
    end
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

-- handle collision with the player-bars
-- idea: check if one corner of the "ball"-rectangle lies within the area of a bar-rectangle
function handleBarCollision()
    
    -- player 1 bar collision
    if  ball_x <= p1_bar_x + BAR_THICKNESS
        and ball_y >= p1_bar_y
        and ball_y <= p1_bar_y + BAR_LENGTH then

            ball_dx = -ball_dx * BALL_SPEEDUP -- change direction and speed the ball up
            ball_dy = ball_dy

            ball_x = p1_bar_x + BAR_THICKNESS + 1 -- always make sure to not get stuck in "endless collisions"
    end

    if  ball_x >= p2_bar_x - BAR_THICKNESS
        and ball_y >= p2_bar_y
        and ball_y <= p2_bar_y + BAR_LENGTH then

            ball_dx = -ball_dx * BALL_SPEEDUP -- change direction and speed the ball up
            ball_dy = ball_dy

            ball_x = p2_bar_x - BAR_THICKNESS - 1 -- always make sure to not get stuck in "endless collisions"
    end

end

-- check and handle collision between the ball and the screen-edge (top / bottom)
function handleScreenEdgeCollision()
    if ball_y <= 0 or ball_y + BALL_HEIGHT >= WINDOW_HEIGHT then
        ball_dy = -ball_dy
    end
end

-- starts a new game by resetting all values to default
function initGame() 
    -- variable definitions for player 1 rectangle
    p1_score = 0
    p1_bar_x = 10
    p1_bar_y = WINDOW_HEIGHT/2 - BAR_LENGTH/2

    -- variable definitions for player 2 rectangle
    p2_score = 0
    p2_bar_x = WINDOW_WIDTH - BAR_THICKNESS - 10
    p2_bar_y = WINDOW_HEIGHT/2 - BAR_LENGTH/2
end

-- handles the display if a player has won the game
function victory(player)
    ball_dx = 0
    ball_dy = 0
    winning_player = player
    game_state = "victory"
end