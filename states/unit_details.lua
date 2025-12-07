state.unit_details={}

state.unit_details={

    unit=nil,

    init=function(self, unit)
        self.unit=unit
    end,

    update=function(self)
        if btnp(🅾️) then 
            current_state=state.map
        end
    end,

    draw=function(self)
        cls(0)
        camera()
        fillp(0x75d5)
        rectfill(0,0,128,128,1)
        fillp()
        print_c("\f7\^o0ffunit details", 64, 8, 7)
        if self.unit != nil then
            print("name: "..self.unit.name, 16, 32, 7)
            print("vof: "..self.unit.vof, 16, 40, 7)
            print("range: "..self.unit.range, 16, 48, 7)
            print("health: "..self.unit.health, 16, 56, 7)
        else
            print_c("no unit selected", 64, 64, 8)
            print_c(self.unit, 64, 72, 8)
        end
        print("\f7\^o0ff🅾️ back", 2, 120, 7)
    end
}