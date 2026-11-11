//
// Simple passthrough fragment shader
//

/*
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
}
*/

// Fragment Shader
precision mediump float; // Set the default precision for floats to medium

varying vec2 v_vTexcoord; // The texture coordinate passed from the vertex shader
uniform float u_time; // A uniform to pass the current time to the shader
varying vec4 v_vColour;

void main()
{
    vec2 uv = v_vTexcoord; // texture coordinate
	// Sample texture...
    vec4 t1 = texture2D(gm_BaseTexture, uv) * v_vColour;

    float speed = 0.38;
    float linewidth = 0.02;
    float grad = 1.0;
    vec4 col1 = vec4(0.3,0.0,0.0,t1.a);
    vec4 col2 = vec4(0.85,0.85,0.85,t1.a);

    // Plot line...
    vec2 linepos = uv;
    linepos.x = linepos.x - mod(u_time*speed,2.0)+0.5;

    float y = linepos.x*grad;
    float s = smoothstep( y-linewidth, y, linepos.y) - smoothstep( y, y+linewidth, linepos.y); 
    
    // Merge texture + Glint
    gl_FragColor = t1 + ((s*col1)+(s*col2));
}