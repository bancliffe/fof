input = {
    X = false,
    O = false,
    UP = false,
    DOWN = false,
    LEFT = false,
    RIGHT = false,
    L1 = false,
    R1 = false,
    L2 = false,
    R2 = false,

    update=function(self)
        self.X = btnp(❎,0)
        self.O = btnp(🅾️,0)
        self.UP = btnp(⬆️,0)
        self.DOWN = btnp(⬇️,0)
        self.LEFT = btnp(⬅️,0)
        self.RIGHT = btnp(➡️,0)
        self.L1 = btnp(⬆️,1)
        self.R1 = btnp(⬇️,1)
        self.L2 = btnp(⬅️,1)
        self.R2 = btnp(➡️,1)
    end
}