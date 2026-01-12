state.map={

    popups={},
    init=function(self)
        music(-1)
        selected_terrain={x=0, y=0} 
        terrain_deck = {}
        selected_unit=1
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

    update=function(self)
        input:update()
        if #self.popups > 0 then
            local popup = self.popups[#self.popups]
            popup:update()
            if not popup.visible then
                del(self.popups, popup)
            end
            return
        end

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
                local popup = make_popup("return to main menu?", 2, 2, 124, 36, true)
                add(self.popups, popup)
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
            if not camera_focused and #self.popups == 0 then
                camera_focused = true
                local tile = terrain_deck[selected_terrain.x][selected_terrain.y]
                if #tile.units > 0 then
                   tile.units[selected_unit].is_selected=true
                end
            else
                popup_tile_contents = make_popup("view tile contents", 2, 2, 124, 124, true)
                popup_tile_contents.update = popup_update_view_tile_contents
                popup_tile_contents.draw = popup_draw_view_tile_contents
                add(self.popups, popup_tile_contents)
            end
        end

        if input.L1 then
            show_los = not show_los
            menuitem(nil, "show los: "..(show_los and "ON" or "OFF"))
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
        if cam.x > 0 and cam.x < 0.1 or cam.x < 0 and cam.x > -0.1 then cam.x=0 end
        if cam.y > 0 and cam.y < 0.1 or cam.y < 0 and cam.y > -0.1 then cam.y=0 end        
    end,

    draw=function(self)
        cls()
        camera(cam.x, cam.y)
        for i=0,3 do
            for j=0,3 do
                terrain_deck[i][j]:draw(32 *i, 32 * j)
            end
        end
        if show_los then
            draw_los_lines()
        end
        rect(selected_terrain.x * 32 + 1, selected_terrain.y * 32 + 1, selected_terrain.x * 32 + 30, selected_terrain.y * 32 + 30, 7)

        -- Draw popup if visible
        if #self.popups > 0 then
            self.popups[#self.popups]:draw()
        end
    end,

    add_popup=function(self, popup)
        add(self.popups, popup)
    end
}

function draw_los_lines()
    local directons ={"NE","N","NW","W","SW","S","SE","E"}
    for d in all(directons) do
        local endx, endy = get_los_from_tile(selected_terrain.x, selected_terrain.y, d)
        line((selected_terrain.x*32)+16, (selected_terrain.y*32)+16, (endx*32)+16, (endy*32)+16, 11)
    end
end

function update_terrain_revealed()
    local directons ={"NE","N","NW"}
    for i=0,3 do
        for d in all(directons) do
            local endx, endy = get_los_from_tile(i, 3, d)
            for j=i, endx do
                for k=0, 3-endy do
                    terrain_deck[j][3-k].revealed = true
                end
            end
        end
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
        terrain_deck[i][3].revealed = true
        terrain_deck[i][3].los= '000000000'
    end
    for i=0,3 do
        terrain_deck[i][2].revealed = true
    end
    update_terrain_revealed()
    load_terrain(card_list)

    -- set potential contact
    contacts={"c","b","a"}
    for i=0,3 do
        for j=0,2 do
            add(terrain_deck[i][j].units,make_unit(contacts[j+1],"potential contact "..contacts[j+1], "-1", "short",0,1))
        end
    end

    -- set starting player units    
    add(terrain_deck[0][3].units, make_unit("1a","1st squad", "-1", "short",3,0))
    add(terrain_deck[0][3].units, make_unit("2a","2nd squad", "-1", "short",3,0))
    add(terrain_deck[0][3].units, make_unit("3a","3rd squad", "-1", "short",3,0))
end

function popup_update_view_tile_contents(self)
    if input.O then
        self.visible = false
    end
    self.tile = terrain_deck[selected_terrain.x][selected_terrain.y]
    if input.LEFT or input.UP then 
        selected_unit -= 1 
        if selected_unit < 1 then selected_unit = #self.tile.units end
    end
    if input.RIGHT or input.DOWN then
        selected_unit += 1
        if selected_unit > #self.tile.units then selected_unit = 1 end
    end
    if #self.tile.units > 0 then
        for i=1, #self.tile.units do
            self.tile.units[i].is_selected = (i == selected_unit)
        end
    end
    if input.X then

        view_unit_popup = make_popup("view unit details", 16, 16, 112, 112, true)
        view_unit_popup.update = popup_update_view_unit_details
        view_unit_popup.draw = popup_draw_view_unit_details
        state.map:add_popup(view_unit_popup)
        logger.log("viewing unit details for unit: "..self.tile.units[selected_unit].name)
        logger.log("total popups: "..#state.map.popups)
    end
end

function popup_draw_view_tile_contents(self)
    camera()
    obscure_behind()
    rectfill(10, 10, 118, 118, 0)
    rect(10, 10, 118, 118, 7)
    if self.tile then
        print_c("tile contents:", 64, 12, 7)
        if #self.tile.units == 0 then
            print("No units present.", 20, 40, 7)
        else
            for i=1, #self.tile.units do
                local unit = self.tile.units[i]
                print(unit.name, 14, 20 + (i * 12), unit.is_selected and 11 or 7)
            end
        end
    end
end

function popup_update_view_unit_details(self)
    if input.O then
        self.visible = false
    end
end

function popup_draw_view_unit_details(self)
    camera()
    obscure_behind()
    rectfill(16, 16, 112, 112, 0)
    rect(16, 16, 112, 112, 7)
    if #terrain_deck[selected_terrain.x][selected_terrain.y].units > 0 then
        local unit = terrain_deck[selected_terrain.x][selected_terrain.y].units[selected_unit]
        print_c("unit details:", 64, 28, 7)
        print("name: "..unit.name, 20, 52, 7)
        print("vof: "..unit.vof, 20, 64, 7)
        print("range: "..unit.range, 20, 76, 7)
        print("health: "..unit.health, 20, 88, 7)
    end
end