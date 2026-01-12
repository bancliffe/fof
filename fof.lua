state={}
current_state=nil

function _init()
    current_state=state.map
    current_state:init()
    logger.init()
end

function _update()
    current_state:update()
end

function _draw()
    current_state:draw()
end