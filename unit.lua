function make_unit(name, attack, range, health)
    local unit = {}
    unit.name = name or "Infantry"
    unit.attack = attack or "small arms"
    unit.range = range or "short"
    unit.health = health or 3 
    unit.special_abilities = {}
    unit.draw = function(self, x, y)
        -- TODO
    end
    return unit
end
