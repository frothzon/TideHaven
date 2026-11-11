/// @description change tbox size

var ww = display_get_gui_width();
var hh = display_get_gui_height();

var w1 = ww * 0.8;
var h1 = hh * 0.4;
var x1 = (ww - w1) * 0.5;
var y1 = hh - 32 - h1;

oText.resize(x1,y1,w1,h1);



