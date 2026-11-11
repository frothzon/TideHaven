/// @description draw self


start_glint_shader(2, 0);
var yy = y;
y = yoffset;
draw_self();
y = yy;
shader_reset();