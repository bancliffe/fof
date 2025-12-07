    
particles={}
max_particles=32
ship_particles={}
max_ship_particles=64

state.main_menu={
    init=function()
        for i=1,max_particles do
            add_menu_particle()
        end
        for i=1,max_ship_particles do
            add_ship_particle()
        end
    end,

    update=function()
        if btnp(❎) then
            current_state=state.map
            current_state.init()
        end
        update_menu_particles()
        update_ship_particles()
    end,

    draw=function()
        cls(0)
        camera()
        draw_menu_particles()
        print_c("\f7\^w\^t\^o5ffshattered orbit", 64,40,2)
        print_c("press x to start", 64, 52, 2)
        print("BY SQUIZM", 2, 122, 2)

       spr(1, 60, 60) -- Planet
       sspr(16, 0, 8, 8, 48 + sin(time()*0.5)*1.5, 70 + cos(time()*0.5)*1.5, 32, 32) 
       
        draw_ship_particles()
        
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