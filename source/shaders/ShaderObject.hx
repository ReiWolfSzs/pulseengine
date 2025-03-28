package shaders;

import openfl.filters.ShaderFilter;
using StringTools;

class ShaderObject {
    public static var shaderManager:ShaderManager = new ShaderManager();

    public static function getShader(shader:String):ShaderFilter
        return shaderManager.translatedShader.get(shader);

	public static function setValue(field:String, value:Dynamic)
	{
        var fieldO:Dynamic;
		fieldO = shaderManager;

        var fieldF:String;
        fieldF = field;

        if (field.contains("."))
        {
			var split = field.split(".");
            fieldF = split[split.length - 1];

			fieldO = Reflect.field(shaderManager, split[0]);

			for (curField in 1...split.length - 1)
				fieldO = Reflect.field(fieldO, split[curField]);
        }

		Reflect.setField(fieldO, fieldF, value);
    }

    public static function update(elapsed)
        shaderManager.update(elapsed);
}