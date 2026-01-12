function make_terrain_card(name, defence,los,cover_type, cover_locations)
    local card={}
    card.units={}
    card.elevation = 0
    card.revealed = false
    card.name = name or "field"
    card.defence = defence or rnd({1,1,1,1,1,1,1,2,2,3})
    card.is_staging_area = false
    card.cover_type = cover_type or "soft"
    card.cover_locations = cover_locations or 2
    card.los = los or rnd({
        "101000101",
        "111111111",
        "000000000",
        "101101101",
        "111000111"
    }) -- 8 directions + center
    card.draw=function(self, x, y)

        if self.revealed == false then
            fillp(0x7ebd)
            rectfill(x, y, x+30, y+30, 5)
            fillp()
            rect(x, y, x+31, y+31, 0)
            -- Draw units
            for i=1, #self.units do
                self.units[i]:draw(x+3, y+3 + 10*(i-1))
            end
            return
        end
        -- dashed outline
        fillp(0b0011001111001100)
        rect(x, y, x+31, y+31, 5)
        fillp()

        -- draw los indicators
        if self.los[1]=="1" then rectfill(x, y, x+5, y+5, 6) end
        if self.los[2]=="1" then rectfill(x+5, y, x+25, y+5, 6) end
        if self.los[3]=="1" then rectfill(x+25, y, x+31, y+5, 6) end

        if self.los[4]=="1" then rectfill(x, y+5, x+10, y+25, 6) end
        if self.los[6]=="1" then rectfill(x+20, y+5, x+31, y+25, 6) end

        if self.los[7]=="1" then rectfill(x, y+25, x+5, y+31, 6) end
        if self.los[8]=="1" then rectfill(x+5, y+25, x+25, y+31, 6) end
        if self.los[9]=="1" then rectfill(x+25, y+25, x+31, y+31, 6) end

        -- fill terrain
        if self.is_staging_area then
           fillp(0x7ebd)
           rectfill(x, y, x+30, y+30, 1)
           fillp()
           rect(x, y, x+31, y+31, 0)
        else
            rectfill(x+1, y+1, x+30, y+30, 0)
            print("\#6"..self.defence, x+26, y+3,0)
            -- TODO: draw elevation if > 0
            if self.elevation > 0 then
                palt(0,false)
                palt(14,true)
                spr(1, x+23, y+23)
                palt()
            end          
        end
        
        -- Draw units
        clip(x+1-cam.x, y+1-cam.y, 29, 29)
        for i=1, #self.units do
            self.units[i]:draw(x+3, y+3 + 12*(i-1))
        end
        clip()
    end
    return card
end

function load_terrain()
    -- TODO: update to use hills and elevation. Requires update to lOS system
    terrain_cards={}
    --card_list="4|open field|0|000000000|soft|2^6|hill|0|111111111|none|0^11|grove|1|111111111|soft|3^1|hedgerow|2|000000000|soft|2^4|hedgerow|2|111000111|soft|2^4|hedgerow|2|101101101|soft|2^2|hedgerow|2|111000000|soft|2^2|hedgerow|2|111001001|soft|2^2|hedgerow|2|111110100|soft|2^2|hedgerow|2|111001001|soft|2^15|farm|2|111111111|hard|1^3|village|3|111111111|hard|3"
    card_list="4|open field|0|000000000|soft|2^11|grove|1|111111111|soft|3^1|hedgerow|2|000000000|soft|2^4|hedgerow|2|111000111|soft|2^4|hedgerow|2|101101101|soft|2^2|hedgerow|2|111000000|soft|2^2|hedgerow|2|111001001|soft|2^2|hedgerow|2|111110100|soft|2^2|hedgerow|2|111001001|soft|2^15|farm|2|111111111|hard|1^3|village|3|111111111|hard|3"
    local data=split(card_list, "^")
    for card in all(data) do
        local params=split(card, "|",false)
        local num_cards = tonum(params[1])
        -- params: number|name|defence|los|cover_type|cover_locations
        for i=1, num_cards do
            local terrain_card = make_terrain_card(
                tostr(params[2]),
                tonum(params[3]),
                tostr(params[4]),
                tostr(params[5]),
                tonum(params[6])
            )
            add(terrain_cards, terrain_card)
        end
    end
end