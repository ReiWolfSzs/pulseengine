package shaders.codes;

import flixel.system.FlxAssets.FlxShader;

class Vhs extends FlxShader
{
    @:glFragmentSource(
    "
        #pragma header

        uniform vec3 iResolution;
        uniform float iTime;

        void main ()
        {
            vec4 c_1;
            vec2 uv_2;
            vec2 tmpvar_3;
            tmpvar_3 = openfl_TextureCoordv.xy;
            uv_2.y = tmpvar_3.y;
            vec2 tmpvar_4;
            tmpvar_4.x = ((tmpvar_3.y * 999.0) + (iTime * 999.0));
            tmpvar_4.y = (((tmpvar_3.x + 999.0) / (tmpvar_3.y + 0.1)) * 19.0);
            vec2 tmpvar_5;
            tmpvar_5 = floor(tmpvar_4);
            vec2 tmpvar_6;
            tmpvar_6 = fract(tmpvar_4);
            vec2 tmpvar_7;
            tmpvar_7 = ((tmpvar_6 * tmpvar_6) * (3.0 - (2.0 * tmpvar_6)));
            vec2 p_8;
            p_8 = (50.0 * fract((
                (tmpvar_5 * 0.3183099)
            + vec2(0.71, 0.113))));
            vec2 p_9;
            p_9 = (tmpvar_5 + vec2(1.0, 0.0));
            p_9 = (50.0 * fract((
                (p_9 * 0.3183099)
            + vec2(0.71, 0.113))));
            vec2 p_10;
            p_10 = (tmpvar_5 + vec2(0.0, 1.0));
            p_10 = (50.0 * fract((
                (p_10 * 0.3183099)
            + vec2(0.71, 0.113))));
            vec2 p_11;
            p_11 = (tmpvar_5 + vec2(1.0, 1.0));
            p_11 = (50.0 * fract((
                (p_11 * 0.3183099)
            + vec2(0.71, 0.113))));
            c_1 = vec4((((
                (sin(iTime) + 2.0)
            * 0.27) * sin(
                ((0.8 - tmpvar_3.y) + (sin((iTime * 3.0)) * 0.1))
            )) * mix (mix (
                (-1.0 + (2.0 * fract((
                (p_8.x * p_8.y)
                * 
                (p_8.x + p_8.y)
                ))))
            , 
                (-1.0 + (2.0 * fract((
                (p_9.x * p_9.y)
                * 
                (p_9.x + p_9.y)
                ))))
            , tmpvar_7.x), mix (
                (-1.0 + (2.0 * fract((
                (p_10.x * p_10.y)
                * 
                (p_10.x + p_10.y)
                ))))
            , 
                (-1.0 + (2.0 * fract((
                (p_11.x * p_11.y)
                * 
                (p_11.x + p_11.y)
                ))))
            , tmpvar_7.x), tmpvar_7.y)));
            vec2 tmpvar_12;
            tmpvar_12.x = (tmpvar_3.y * 999.0);
            tmpvar_12.y = (iTime * 9.0);
            vec2 tmpvar_13;
            tmpvar_13 = floor(tmpvar_12);
            vec2 tmpvar_14;
            tmpvar_14 = fract(tmpvar_12);
            vec2 tmpvar_15;
            tmpvar_15 = ((tmpvar_14 * tmpvar_14) * (3.0 - (2.0 * tmpvar_14)));
            vec2 p_16;
            p_16 = (50.0 * fract((
                (tmpvar_13 * 0.3183099)
            + vec2(0.71, 0.113))));
            vec2 p_17;
            p_17 = (tmpvar_13 + vec2(1.0, 0.0));
            p_17 = (50.0 * fract((
                (p_17 * 0.3183099)
            + vec2(0.71, 0.113))));
            vec2 p_18;
            p_18 = (tmpvar_13 + vec2(0.0, 1.0));
            p_18 = (50.0 * fract((
                (p_18 * 0.3183099)
            + vec2(0.71, 0.113))));
            vec2 p_19;
            p_19 = (tmpvar_13 + vec2(1.0, 1.0));
            p_19 = (50.0 * fract((
                (p_19 * 0.3183099)
            + vec2(0.71, 0.113))));
            uv_2.x = (tmpvar_3.x + (0.001 * mix (
                mix ((-1.0 + (2.0 * fract(
                ((p_16.x * p_16.y) * (p_16.x + p_16.y))
                ))), (-1.0 + (2.0 * fract(
                ((p_17.x * p_17.y) * (p_17.x + p_17.y))
                ))), tmpvar_15.x)
            , 
                mix ((-1.0 + (2.0 * fract(
                ((p_18.x * p_18.y) * (p_18.x + p_18.y))
                ))), (-1.0 + (2.0 * fract(
                ((p_19.x * p_19.y) * (p_19.x + p_19.y))
                ))), tmpvar_15.x)
            , tmpvar_15.y)));
            vec4 tmpvar_20;
            tmpvar_20.w = 1.0;
            tmpvar_20.x = flixel_texture2D (bitmap, (uv_2 + vec2(-0.001, 0.0))).x;
            tmpvar_20.y = flixel_texture2D (bitmap, uv_2).y;
            tmpvar_20.z = flixel_texture2D (bitmap, (uv_2 + vec2(0.001, 0.0))).z;
            c_1 = (c_1 + tmpvar_20);
            c_1 = (c_1 * (1.0 + (0.1 * 
                sin((((tmpvar_3.y * iResolution.y) * 3.141593) / 2.0))
            )));
            float tmpvar_21;
            tmpvar_21 = (1.1 * abs((uv_2.x - 0.5)));
            float tmpvar_22;
            tmpvar_22 = (1.1 * abs((tmpvar_3.y - 0.5)));
            c_1 = (c_1 * ((1.0 - 
                (tmpvar_21 * tmpvar_21)
            ) - (tmpvar_22 * tmpvar_22)));
            vec2 tmpvar_23;
            tmpvar_23 = floor((uv_2 * 270.0));
            uv_2 = tmpvar_23;
            vec2 p_24;
            p_24 = -(tmpvar_23);
            float v_25;
            float tmpvar_26;
            tmpvar_26 = (iTime * 2.0);
            vec3 tmpvar_27;
            tmpvar_27.yz = vec2(1.0, 1.0);
            tmpvar_27.x = ((p_24.y * 0.01) + tmpvar_26);
            vec3 f_28;
            vec3 tmpvar_29;
            tmpvar_29 = floor(tmpvar_27);
            vec3 tmpvar_30;
            tmpvar_30 = fract(tmpvar_27);
            f_28 = ((tmpvar_30 * tmpvar_30) * (3.0 - (2.0 * tmpvar_30)));
            float tmpvar_31;
            tmpvar_31 = ((tmpvar_29.x + (tmpvar_29.y * 57.0)) + (113.0 * tmpvar_29.z));
            vec3 tmpvar_32;
            tmpvar_32.yz = vec2(1.0, 1.0);
            tmpvar_32.x = (((p_24.y * 0.011) + 1000.0) + tmpvar_26);
            vec3 f_33;
            vec3 tmpvar_34;
            tmpvar_34 = floor(tmpvar_32);
            vec3 tmpvar_35;
            tmpvar_35 = fract(tmpvar_32);
            f_33 = ((tmpvar_35 * tmpvar_35) * (3.0 - (2.0 * tmpvar_35)));
            float tmpvar_36;
            tmpvar_36 = ((tmpvar_34.x + (tmpvar_34.y * 57.0)) + (113.0 * tmpvar_34.z));
            vec3 tmpvar_37;
            tmpvar_37.yz = vec2(1.0, 1.0);
            tmpvar_37.x = (((p_24.y * 0.51) + 421.0) + tmpvar_26);
            vec3 f_38;
            vec3 tmpvar_39;
            tmpvar_39 = floor(tmpvar_37);
            vec3 tmpvar_40;
            tmpvar_40 = fract(tmpvar_37);
            f_38 = ((tmpvar_40 * tmpvar_40) * (3.0 - (2.0 * tmpvar_40)));
            float tmpvar_41;
            tmpvar_41 = ((tmpvar_39.x + (tmpvar_39.y * 57.0)) + (113.0 * tmpvar_39.z));
            vec2 tmpvar_42;
            tmpvar_42.x = (p_24.x + (iTime * 0.01));
            tmpvar_42.y = p_24.y;
            vec4 p4_43;
            vec4 tmpvar_44;
            tmpvar_44 = fract((tmpvar_42.xyxy * vec4(443.8975, 397.2973, 491.1871, 470.7827)));
            p4_43 = (tmpvar_44 + dot (tmpvar_44.wzxy, (tmpvar_44 + 19.19)));
            vec4 tmpvar_45;
            tmpvar_45.x = (p4_43.x * p4_43.y);
            tmpvar_45.y = (p4_43.x * p4_43.z);
            tmpvar_45.z = (p4_43.y * p4_43.w);
            tmpvar_45.w = (p4_43.x * p4_43.w);
            v_25 = (((
                mix (mix (mix (fract(
                (sin(tmpvar_31) * 43758.55)
                ), fract(
                (sin((tmpvar_31 + 1.0)) * 43758.55)
                ), f_28.x), mix (fract(
                (sin((tmpvar_31 + 57.0)) * 43758.55)
                ), fract(
                (sin((tmpvar_31 + 58.0)) * 43758.55)
                ), f_28.x), f_28.y), mix (mix (fract(
                (sin((tmpvar_31 + 113.0)) * 43758.55)
                ), fract(
                (sin((tmpvar_31 + 114.0)) * 43758.55)
                ), f_28.x), mix (fract(
                (sin((tmpvar_31 + 170.0)) * 43758.55)
                ), fract(
                (sin((tmpvar_31 + 171.0)) * 43758.55)
                ), f_28.x), f_28.y), f_28.z)
            * 
                mix (mix (mix (fract(
                (sin(tmpvar_36) * 43758.55)
                ), fract(
                (sin((tmpvar_36 + 1.0)) * 43758.55)
                ), f_33.x), mix (fract(
                (sin((tmpvar_36 + 57.0)) * 43758.55)
                ), fract(
                (sin((tmpvar_36 + 58.0)) * 43758.55)
                ), f_33.x), f_33.y), mix (mix (fract(
                (sin((tmpvar_36 + 113.0)) * 43758.55)
                ), fract(
                (sin((tmpvar_36 + 114.0)) * 43758.55)
                ), f_33.x), mix (fract(
                (sin((tmpvar_36 + 170.0)) * 43758.55)
                ), fract(
                (sin((tmpvar_36 + 171.0)) * 43758.55)
                ), f_33.x), f_33.y), f_33.z)
            ) * mix (
                mix (mix (fract((
                sin(tmpvar_41)
                * 43758.55)), fract((
                sin((tmpvar_41 + 1.0))
                * 43758.55)), f_38.x), mix (fract((
                sin((tmpvar_41 + 57.0))
                * 43758.55)), fract((
                sin((tmpvar_41 + 58.0))
                * 43758.55)), f_38.x), f_38.y)
            , 
                mix (mix (fract((
                sin((tmpvar_41 + 113.0))
                * 43758.55)), fract((
                sin((tmpvar_41 + 114.0))
                * 43758.55)), f_38.x), mix (fract((
                sin((tmpvar_41 + 170.0))
                * 43758.55)), fract((
                sin((tmpvar_41 + 171.0))
                * 43758.55)), f_38.x), f_38.y)
            , f_38.z)) * (fract(tmpvar_45).x + 0.3));
            float tmpvar_46;
            tmpvar_46 = (v_25 + 0.3);
            v_25 = tmpvar_46;
            if ((tmpvar_46 < 0.8)) {
                v_25 = 0.0;
            };
            vec2 tmpvar_47;
            tmpvar_47.x = (0.5 + (0.5 * sin(iTime)));
            tmpvar_47.y = tmpvar_23.y;
            vec4 tmpvar_48;
            tmpvar_48.w = 1.0;
            tmpvar_48.xyz = vec3(v_25);
            vec4 tmpvar_49;
            tmpvar_49.w = 1.0;
            tmpvar_49.xyz = (flixel_texture2D (bitmap, tmpvar_47).xyz * 0.06);
            gl_FragColor = tmpvar_48 + c_1 + tmpvar_49;
        }
    "
    )
    public function new()
    {
        super();
    }
}