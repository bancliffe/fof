function make_unit(name, attack, range, health)
    local unit = {}
    unit.name = name or "A1"
    unit.vof = attack or "-1"
    unit.range = range or "short"
    unit.health = health or 3 
    unit.special_abilities = {}
    unit.draw = function(self, x, y)
        rectfill(x,y,x+8,y+8,8)
    end
    return unit
end
