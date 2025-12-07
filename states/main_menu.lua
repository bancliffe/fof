particles={}
max_particles=32
ship_particles={}
max_ship_particles=64

state.main_menu={

    start_game=false,
    start_timer=0,

    init=function(self)
        for i=1,max_particles do
            add_menu_particle()
        end
        for i=1,max_ship_particles do
            add_ship_particle()
        end
        music(0)
    end,

    update=function(self)
        if btnp(❎) then
            self.start_game = true
        end

        if self.start_game then
            self.start_timer +=1
            if self.start_timer >60 then
                current_state=state.map
                current_state:init()
                self.start_game=false
                self.start_timer=0
            end
        end

        update_menu_particles()
        update_ship_particles()
    end,

    draw=function(self)
        cls(0)
        camera()
        draw_menu_particles()

        -- center for the planet
        local cx, cy = 64, 64
        local base_size = 8

        if not self.start_game then
            local dw = base_size
            local dh = base_size
            -- sprite 1 is at (8,0) in the sprite sheet (32x32)
            palt(0,false)
            palt(14, true)
            sspr(24, 0, 32, 32, cx - dw/2, cy - dh/2, dw, dh)
            palt()

            print_c("\f7\^w\^t\^o5ffshattered orbit", 64,16,2)
            print_c("press x to start", 64, 32, 7)
            -- draw ship
            sspr(16, 0, 8, 8, 48 + sin(time()*0.5)*1.5, 70 + cos(time()*0.5)*1.5, 32, 32) 
            draw_ship_particles()        
            
            print("BY SQUIZM", 2, 122, 5)
        else
            -- grow planet centered over time (self.start_timer)
            local t = mid(0, self.start_timer/60, 1) -- 0..1 over 60 frames
            local max_size = 128
            -- ease (optional): smoothstep like ease-in-out
            local ease = t * t * (3 - 2 * t)
            local size = base_size + (max_size - base_size) * ease
            palt(0,false)
            palt(14, true)
            sspr(24, 0, 32, 32, cx - size/2, cy - size/2, size, size)
            palt()

            -- draw ship
            sspr(16, 0, 8, 8, 48 + sin(time()*0.5)*1.5, 70 + cos(time()*0.5)*1.5, 32, 32) 
            draw_ship_particles()        
            
            print("BY SQUIZM", 2, 122, 5) 
    

            poke(0x5f34,0x2)
            t = mid(0, self.start_timer/60, 1)
            local rad = 128 * (1 - t)
            if rad > 1 then
	            circfill(64,64,rad,0|0x1800)
            end
        end
    end
}

function add_ship_particle()
    add(ship_particles,{
            x=(48+16) + sin(time()*0.5)*1.5,
            y=(70+16) + cos(time()*0.5)*1.5,
            dx=rnd(1)-1,
            dy=rnd(1),
            rad=rnd(3),
			act=30+rnd(60),
            clr=10,
            spd=rnd(1)+0.5,
            ang=rnd(1)
        })
end

function update_ship_particles()
    for p in all(ship_particles) do
        p.y+=p.dy *p.spd
        p.x+=sin(p.ang)*0.1
        p.spd+=0.5
		p.act-=1
        p.ang+=0.01
		if p.act<0 then
			del(ship_particles,p)
			add_ship_particle()
		end
		if p.act<55 then p.clr=9 p.rad-=0.05 end
		if p.act<40 then p.clr=2 p.rad-=0.05 end
    end
end

function draw_ship_particles()
    for p in all(ship_particles) do
        circfill(p.x, p.y,p.rad,p.clr)
    end
end

function update_menu_particles()
	for p in all(particles) do
		p.x-=p.dx * p.spd
        p.y-=p.dy * p.spd
        p.spd+=0.1
		if p.x<0 or p.y<0 or p.x>128 or p.y>128 then
			del(particles,p)
			add_menu_particle()
		end
	end
end

function draw_menu_particles()
	for p in all(particles) do
		circfill(p.x, p.y,p.rad,p.clr)
	end
end

function add_menu_particle()
	add(particles,{
			x=64,
			y=64,
			dx=rnd(2)-1,
			dy=rnd(2)-1,
			rad=0,
			clr=rnd({5,6,7}),
            spd=0.1
		})
end