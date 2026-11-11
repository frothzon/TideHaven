//
// Outline Shader -- outlines a sprite
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
const float inset = 4.0;
const float factor = 0.8;

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
	
	bool hasNoAlpha1 = false;
	bool hasNoAlpha2 = false;
	/*
	if(texture2D( gm_BaseTexture, v_vTexcoord + offsetX * inset).a == 0.){
		hasNoAlpha = true;
	}
	else if(texture2D( gm_BaseTexture, v_vTexcoord - offsetX * inset).a == 0.){
		hasNoAlpha = true;
	}
	*/
	if(texture2D( gm_BaseTexture, v_vTexcoord + offsetY * inset).a == 0.){
		hasNoAlpha1 = true;
	}
	else if(texture2D( gm_BaseTexture, v_vTexcoord - offsetY * inset).a == 0.){
		hasNoAlpha2 = true;
	}

    /// get the alpha at the current pixel drawn
    float minAlpha = texture2D( gm_BaseTexture, v_vTexcoord ).a;
    
    /// Pass information to pixel
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    /// set color to black
    if(maxAlpha >= 1.0 && minAlpha <= .2){
        gl_FragColor.rgb *= 0.;
    }
	if(minAlpha > 0.2){
		// toon shading on edges within the inset of shape
		if(hasNoAlpha1) {
			/// make darker by factor
			gl_FragColor.rgb *= factor;
		} else if(hasNoAlpha2){
			/// force to blend to lighter color by 1/3
			gl_FragColor.rgb = (gl_FragColor.rgb*2. + 1.) * 0.3;
		}
	}
    /// get alpha info
    gl_FragColor.a = maxAlpha;
}

