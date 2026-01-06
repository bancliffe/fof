function print_c(str, x, y, c)
    str_width = print(str, 0, -20, c)
    print(str, x-(str_width/2), y, c)
end

function lerp(a,b,t)
    return a+(b-a)*t
end

function make_popup(text, x, y, w, h, isvisible)
    return {
        text=text,
        x=x or 0,
        y=y or 0,
        w=w or 0,
        h=h or 0,
        visible=isvisible or false,
        update = function(self)
            if input.O then
                self.visible = false
            end
        end,
        draw=function(self)
            for i=0,64 do
                line(0, i*2, 128, i*2, 0)
            end
            rectfill(self.x, self.y, self.x + self.w, self.y + self.h, 0)
            rect(self.x, self.y, self.x + self.w, self.y + self.h, 7)
            print_c(self.text, self.x + self.w / 2, self.y + 10, 7)
            print_c("🅾️ cancel", self.x + self.w / 2, self.y + self.h - 18, 7)
            print_c("❎ ok", self.x + self.w / 2, self.y + self.h - 10, 7)
        end    
    }
end

function obscure_behind()
    for i=0, 64 do
        line(0, i*2, 127, i*2, 0)
    end
end