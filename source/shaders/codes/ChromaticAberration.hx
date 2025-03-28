package shaders.codes;

import flixel.system.FlxAssets.FlxShader;

class ChromaticAberration extends FlxShader
{
    public var tween:Bool = false;
	@:glFragmentSource("
    #pragma header
    
    uniform float amount;

    void main()
    {
        vec2 uv = openfl_TextureCoordv.xy;
        vec2 uvRed = uv;
        vec2 uvBlue = uv;
        float s = amount;
        uvRed.x += s;
        uvBlue.x -= s;

        gl_FragColor =  flixel_texture2D(bitmap, uv);

        gl_FragColor.r = flixel_texture2D(bitmap, uvRed).r;
        gl_FragColor.b = flixel_texture2D(bitmap, uvBlue).b;
    }")
	public function new()
	{
		super();
	}
}