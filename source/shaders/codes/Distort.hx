package shaders.codes;

import flixel.system.FlxAssets.FlxShader;

class Distort extends FlxShader
{ // https://www.shadertoy.com/view/ldtBWl
	@:glFragmentSource("
    #pragma header
    uniform sampler2D abstractstuff;
    uniform float intensity;
    void main()
    {
        vec2 uv = openfl_TextureCoordv.xy;
       
        vec4 dist = flixel_texture2D(abstractstuff, uv);
        vec2 distorter = dist.rr * vec2(intensity,intensity);
        vec4 color = flixel_texture2D(bitmap, uv + distorter);
        
        
        gl_FragColor = color.rgba;
        
    }")
	public function new()
	{
		super();
	}
}