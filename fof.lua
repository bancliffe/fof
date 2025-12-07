state={}
current_state=nil

function _init()
    current_state=state.main_menu
    current_state:init()
end

function _update()
    current_state:update()
end

function _draw()
    current_state:draw()
end