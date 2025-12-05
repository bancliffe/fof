function make_terrain_card(name, defence, cover_type, cover_locations, los)
    local card={}
    card.name = name or "field"
    card.defence = defence or rnd({1,1,1,1,1,1,1,2,2,3})
    card.is_staging_area = false
    card.potential_contact = nil
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
           rectfill(x, y, x+30, y+30, 5)
           fillp()
           rect(x, y, x+31, y+31, 0)
        else
            rectfill(x+1, y+1, x+30, y+30, 0)
            print("\#6"..self.defence, x+26, y+3,0)
            if self.potential_contact then
                print("\#1"..self.potential_contact, x+3, y+24,7)
            end
        end             
    end
    return card
end