function make_unit(icon_text, name, vof, range, health, faction)
    local unit = {}
    unit.faction = faction or 0 -- 0=player, 1=enemy, 2=neutral
    unit.name = name or "not defined"
    unit.icon_text = icon_text or 'z'
    unit.vof = vof or "-1"
    unit.range = range or "short"
    unit.health = health or 0 
    unit.special_abilities = {}
    unit.is_selected = false
    unit.in_cover = false
    unit.draw = function(self, x, y)
        -- Units should be 12x12
        rect(x,y,x+11,y+11,unit.faction == 0 and 11 or 8)
        rectfill(x+1,y+1,x+10,y+10, unit.faction == 0 and 3 or 8)
        print_c(self.icon_text, x+6, y+3, 7)
        if self.is_selected then
            rect(x,y,x+11,y+11,7)
        end
        for i=1, self.health do
            pset(x+2+(i-1)*4, y+10, 9)
        end
    end
    return unit
    end
