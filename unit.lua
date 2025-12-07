function make_unit(name, vof, range, health)
    local unit = {}
    unit.name = name or "A1"
    unit.vof = vof or "-1"
    unit.range = range or "short"
    unit.health = health or 3 
    unit.special_abilities = {}
    unit.is_selected = false
    unit.draw = function(self, x, y)
        rectfill(x,y,x+4,y+4,3)
        if self.is_selected then
            rect(x-1,y-1,x+5,y+5,7)
        end
    end
    return unit
end
