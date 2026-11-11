//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)
attribute float in_Weight;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;

void main()
{
	vec4 trans_pos = vec4(in_Position.xyz, 1.0);
	
	trans_pos.x += smoothstep(0., 1., in_Weight * 0.5) * 6. * sin(u_time + in_Position.y * 0.02 + in_Position.x * 0.01);
	
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * trans_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}
