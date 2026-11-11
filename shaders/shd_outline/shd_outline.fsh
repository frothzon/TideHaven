//
// Outline Shader -- outlines a sprite
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

/// pass in variables
uniform float pixelH;
uniform float pixelW;

void main()
{
    /// new variables
    vec2 offsetX;   /// x-vector (0,1)
    offsetX.x = pixelW;
    vec2 offsetY;   /// y-vector (1,0)
    offsetY.y = pixelH;
    
    /// Find the alpha around the pixel being drawn, and return the highest one
    float maxAlpha = texture2D( gm_BaseTexture, v_vTexcoord ).a;
    maxAlpha += ceil(texture2D( gm_BaseTexture, v_vTexcoord + offsetX).a);
    maxAlpha += ceil(texture2D( gm_BaseTexture, v_vTexcoord - offsetX).a);
    maxAlpha += ceil(texture2D( gm_BaseTexture, v_vTexcoord + offsetY).a);
    maxAlpha += ceil(texture2D( gm_BaseTexture, v_vTexcoord - offsetY).a);

    /// get the alpha at the current pixel drawn
    float minAlpha = texture2D( gm_BaseTexture, v_vTexcoord ).a;
    
    /// Pass information to pixel
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    /// set color to black
    if(maxAlpha >= 1.0 && minAlpha <= .2){
        gl_FragColor.r = 0.0;
        gl_FragColor.g = 0.0;
        gl_FragColor.b = 0.0;
    }
    /// get alpha info
    gl_FragColor.a = maxAlpha;
}

