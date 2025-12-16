state.map={

    init=function()
        music(-1)
        terrain_deck = {}
        selected_terrain={x=0, y=0} 
        selected_unit=1 -- default to the first unit in the tile
        setup_test_mission()

        show_los = false
        camera_focused = false
        camera_dest={x=0,y=0}
        cam={x=0,y=0}
                
        menuitem(1, "generate mission", setup_test_mission)
        menuitem(2, "show los: OFF",
            function()
                show_los = not show_los
                menuitem(nil, "show los: "..(show_los and "ON" or "OFF"))
                return true
            end
        )
    end,

    update=function()
        input:update()
        if not camera_focused then
            if input.LEFT then selected_terrain.x = (selected_terrain.x - 1) % 4 end
            if input.RIGHT then selected_terrain.x = (selected_terrain.x + 1) % 4 end
            if input.UP then selected_terrain.y = (selected_terrain.y - 1) % 4 end
            if input.DOWN then selected_terrain.y = (selected_terrain.y + 1) % 4 end
        else
            if input.LEFT or input.UP then 
                selected_unit -= 1 
                if selected_unit < 1 then selected_unit = #terrain_deck[selected_terrain.x][selected_terrain.y].units end
            end
            if input.RIGHT or input.DOWN then 
                selected_unit += 1 
                if selected_unit > #terrain_deck[selected_terrain.x][selected_terrain.y].units then selected_unit = 1 end
            end
            for i=1, #terrain_deck[selected_terrain.x][selected_terrain.y].units do
                terrain_deck[selected_terrain.x][selected_terrain.y].units[i].is_selected = (i == selected_unit)
            end
        end

        if input.O then 
            if not camera_focused then
                current_state=state.main_menu
                current_state.init()
            else
                camera_focused = false
                local tile = terrain_deck[selected_terrain.x][selected_terrain.y]
                if #tile.units >0 then
                    terrain_deck[selected_terrain.x][selected_terrain.y].units[selected_unit].is_selected = false
                    selected_unit = 1
                end
            end
            selected_unit = 1
        end
        if input.X then 
            if not camera_focused then
                camera_focused = true
                local tile = terrain_deck[selected_terrain.x][selected_terrain.y]
                if #tile.units > 0 then
                   tile.units[selected_unit].is_selected=true
                end
            else
                current_state=state.unit_details
                local tile = terrain_deck[selected_terrain.x][selected_terrain.y]
                current_state:init(tile.units[selected_unit])
            end
        end

        if camera_focused then
            camera_dest.x = (selected_terrain.x * 32)-4
            camera_dest.y = (selected_terrain.y * 32)-4
        else
            camera_dest.x = 0
            camera_dest.y = 0
        end
        cam.x=lerp(cam.x,camera_dest.x,0.25)
        cam.y=lerp(cam.y,camera_dest.y,0.25)           
    end,

    draw=function()
        cls()
        camera(cam.x, cam.y)

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
}

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

    -- set starting units
    terrain_deck[0][3].units = {}
    add(terrain_deck[0][3].units, make_unit("dudeguy 1", "-1", "short"))
    add(terrain_deck[0][3].units, make_unit("dudeguy 2", "-1", "short"))
end