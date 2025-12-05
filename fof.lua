function _init()
    terrain_deck = {}
    selected_terrain={x=0, y=0} 
    setup_test_mission()

    show_los = false
    menuitem(1, "generate mission", setup_test_mission)
    -- Setup camera
    -- camera_dest={x=64, y=64}
    -- cam={x=64,y=64}
end

function _update()
    -- Update game state
    if btnp(0) then selected_terrain.x = (selected_terrain.x - 1) % 4 end
    if btnp(1) then selected_terrain.x = (selected_terrain.x + 1) % 4 end
    if btnp(2) then selected_terrain.y = (selected_terrain.y - 1) % 4 end
    if btnp(3) then selected_terrain.y = (selected_terrain.y + 1) % 4 end

    if btnp(4) then show_los = not show_los end
    --[[
    camera_dest.x = (selected_terrain.x * 32) - 48
    camera_dest.y = (selected_terrain.y * 32) - 48
    cam.x=lerp(cam.x,camera_dest.x,0.1)
    cam.y=lerp(cam.y,camera_dest.y,0.1)
    ]]
end

function _draw()
    -- Draw game elements
    cls()
    -- camera(cam.x, cam.y)
    for i=0,3 do
        for j=0,3 do
            terrain_deck[i][j]:draw(32 * (i), 32 * (j))
        end
    end
    if show_los then
        draw_los_lines()
    end
    rect(selected_terrain.x * 32 + 1, selected_terrain.y * 32 + 1, selected_terrain.x * 32 + 30, selected_terrain.y * 32 + 30, 7)
end

function draw_los_lines()
    local directons ={"NE","N","NW","W","SW","S","SE","E"}
    for d in all(directons) do
        local endx, endy = get_los_from_tile(selected_terrain.x, selected_terrain.y, d)
        line((selected_terrain.x*32)+16, (selected_terrain.y*32)+16, (endx*32)+16, (endy*32)+16, 11)
    end
end

function get_los_from_tile(start_x, start_y, direction)
    local tile = terrain_deck[start_x][start_y]
    if direction == "NW" then
        if start_x==0 or start_y==0 then
            return start_x, start_y
        end
        if terrain_deck[start_x-1][start_y-1].los[1] == "1" then
            return start_x-1, start_y-1
        else
            return get_los_from_tile(start_x-1, start_y-1, direction)
        end
    elseif direction == "N" then
        if start_y==0 then
            return start_x, start_y
        end
        if terrain_deck[start_x][start_y-1].los[2] == "1" then
            return start_x, start_y-1
        else
            return get_los_from_tile(start_x, start_y-1, direction)
        end
    elseif direction == "NE" then
        if start_x==3 or start_y==0 then
            return start_x, start_y
        end
        if terrain_deck[start_x+1][start_y-1].los[3] == "1" then
            return start_x+1, start_y-1
        else
            return get_los_from_tile(start_x+1, start_y-1, direction)
        end
    elseif direction == "W" then
        if start_x==0 then
            return start_x, start_y
        end
        if terrain_deck[start_x-1][start_y].los[4] == "1" then
            return start_x-1, start_y
        else
            return get_los_from_tile(start_x-1, start_y, direction)
        end 
    elseif direction == "E" then
        if start_x==3 then
            return start_x, start_y
        end
        if terrain_deck[start_x+1][start_y].los[6] == "1" then
            return start_x+1, start_y
        else
            return get_los_from_tile(start_x+1, start_y, direction)
        end
    elseif direction == "SW" then
        if start_x == 0 or start_y==3 then
            return start_x, start_y
        end
        if terrain_deck[start_x-1][start_y+1].los[7] == "1" then
            return start_x-1, start_y+1
        else
            return get_los_from_tile(start_x-1, start_y+1, direction)
        end
    elseif direction == "S" then
        if start_y==3 then
            return start_x, start_y
        end
        if terrain_deck[start_x][start_y+1].los[8] == "1" then
            return start_x, start_y+1
        else
            return get_los_from_tile(start_x, start_y+1, direction)
        end
    elseif direction == "SE" then
        if start_x==3 or start_y==3 then
            return start_x, start_y
        end
        if terrain_deck[start_x+1][start_y+1].los[9] == "1" then
            return start_x+1, start_y+1
        else
            return get_los_from_tile(start_x+1, start_y+1, direction)
        end
    end
end

function lerp(a,b,t)
    return a+(b-a)*t
end

function setup_test_mission()
    for i=0,3 do
        terrain_deck[i] = {}
        for j=0,3 do
            terrain_deck[i][j] = make_terrain_card()
        end
    end
    -- set staging area
    for i=0,3 do
        terrain_deck[i][3].is_staging_area = true
        terrain_deck[i][3].los= '000000000'
    end

    -- set potential contact
    contacts={"c","b","a"}
    for i=0,3 do
        for j=0,3 do
            terrain_deck[i][j].potential_contact=contacts[j+1]
        end
    end
end