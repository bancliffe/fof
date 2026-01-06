function make_unit(icon_text, name, vof, range, health, faction)
    local unit = {}
    unit.faction = faction or 0 -- 0=player, 1=enemy, 2=neutral
    unit.name = name or "not defined"
    unit.icon_text = icon_text or 'z'
    unit.vof = vof or "-1"
    unit.range = range or "short"
    unit.health = health or 3 
    unit.special_abilities = {}
    unit.is_selected = false
    unit.draw = function(self, x, y)
        rectfill(x,y,x+(#self.icon_text*4),y+6, unit.faction == 0 and 3 or 8)
        print(self.icon_text, x+1, y+1, 7)
        if self.is_selected then
            rect(x-1,y-1,x+(#self.icon_text*4)+1,y+7,7)
        end
    end
    return unit
end
