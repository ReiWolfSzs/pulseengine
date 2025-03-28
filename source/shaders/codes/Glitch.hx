package shaders.codes;

import flixel.system.FlxAssets.FlxShader;

class Glitch extends FlxShader {
    @:glFragmentSource(
    "
        #pragma header

        uniform float iTime;
        uniform bool isDad;
        void main ()
        {
            float noise_1;
            vec2 tmpvar_2;
            tmpvar_2 = (openfl_TextureCoordv.xy);
            vec2 p_3;
            p_3 = tmpvar_2;
            float seed_4;
            seed_4 = (floor((iTime * 15.0)) / 15.0);
            float g_6;
            vec2 q_7;
            q_7 = fract(tmpvar_2);
            g_6 = -1.0;
            for (int i_5 = 0; i_5 < 3; i_5++) {
                float tmpvar_8;
                tmpvar_8 = (float(i_5) + 1.0);
                float tmpvar_9;
                tmpvar_9 = fract((sin(
                (tmpvar_8 + seed_4)
                ) * 43768.55));
                float v_10;
                v_10 = (tmpvar_8 + seed_4);
                vec2 tmpvar_11;
                tmpvar_11.x = fract((sin(
                dot ((v_10 + vec2(77.77, 77.77)), vec2(12.9898, 78.233))
                ) * 43768.55));
                tmpvar_11.y = fract((sin(
                dot ((v_10 + vec2(999.999, 999.999)), vec2(12.9898, 78.233))
                ) * 43768.55));
                q_7 = (((p_3 * 10.0) * tmpvar_8) + tmpvar_11);
                float v_12;
                v_12 = (tmpvar_8 + seed_4);
                vec2 tmpvar_13;
                tmpvar_13.x = fract((sin(
                dot ((v_12 + vec2(77.77, 77.77)), vec2(12.9898, 78.233))
                ) * 43768.55));
                tmpvar_13.y = fract((sin(
                dot ((v_12 + vec2(999.999, 999.999)), vec2(12.9898, 78.233))
                ) * 43768.55));
                q_7 = (q_7 * ((tmpvar_13 * 2.0) - 1.0));
                vec2 tmpvar_14;
                tmpvar_14 = floor(q_7);
                float tmpvar_15;
                tmpvar_15 = fract((sin(
                dot (tmpvar_14, vec2(12.9898, 78.233))
                ) * 43768.55));
                if ((tmpvar_15 < 0.005)) {
                vec2 tmpvar_16;
                tmpvar_16.x = fract((sin(
                    dot ((tmpvar_14 + vec2(77.77, 77.77)), vec2(12.9898, 78.233))
                ) * 43768.55));
                tmpvar_16.y = fract((sin(
                    dot ((tmpvar_14 + vec2(999.999, 999.999)), vec2(12.9898, 78.233))
                ) * 43768.55));
                p_3 = (p_3 + ((tmpvar_16 * 2.0) - 1.0));
                g_6 = tmpvar_9;
                };
            };
            vec3 tmpvar_17;
            if ((g_6 < 0.0)) {
                tmpvar_17 = flixel_texture2D (bitmap, tmpvar_2).xyz;
            } else {
                vec2 tmpvar_18;
                tmpvar_18.y = 0.0;
                tmpvar_18.x = (g_6 * vec3(0.16, 0.04, -0.8)).x;
                vec2 tmpvar_19;
                tmpvar_19.y = 0.0;
                tmpvar_19.x = (g_6 * vec3(0.16, 0.04, -0.8)).y;
                vec2 tmpvar_20;
                tmpvar_20.y = 0.0;
                tmpvar_20.x = (g_6 * vec3(0.16, 0.04, -0.8)).z;
                vec3 tmpvar_21;
                tmpvar_21.x = flixel_texture2D (bitmap, (tmpvar_2 + tmpvar_18)).x;
                tmpvar_21.y = flixel_texture2D (bitmap, (tmpvar_2 + tmpvar_19)).y;
                tmpvar_21.z = flixel_texture2D (bitmap, (tmpvar_2 + tmpvar_20)).z;
                tmpvar_17 = tmpvar_21;
            };
            if (isDad) {
                vec4 tmpvar_22;
                tmpvar_22.w = 1.0;
                tmpvar_22.xyz = tmpvar_17;
                gl_FragColor = tmpvar_22;
            };
            float tmpvar_23;
            tmpvar_23 = (iTime * 2.0);
            vec2 tmpvar_24;
            tmpvar_24.x = tmpvar_23;
            tmpvar_24.y = (tmpvar_2.y * 0.3);
            vec3 g_25;
            vec3 m_26;
            vec4 x12_27;
            vec2 tmpvar_28;
            tmpvar_28 = floor((tmpvar_24 + dot (tmpvar_24, vec2(0.3660254, 0.3660254))));
            vec2 tmpvar_29;
            tmpvar_29 = ((tmpvar_24 - tmpvar_28) + dot (tmpvar_28, vec2(0.2113249, 0.2113249)));
            vec2 tmpvar_30;
            if ((tmpvar_29.x > tmpvar_29.y)) {
                tmpvar_30 = vec2(1.0, 0.0);
            } else {
                tmpvar_30 = vec2(0.0, 1.0);
            };
            vec4 tmpvar_31;
            tmpvar_31 = (tmpvar_29.xyxy + vec4(0.2113249, 0.2113249, -0.5773503, -0.5773503));
            x12_27.zw = tmpvar_31.zw;
            x12_27.xy = (tmpvar_31.xy - tmpvar_30);
            vec2 tmpvar_32;
            tmpvar_32 = (tmpvar_28 - (floor(
                (tmpvar_28 * 0.003460208)
            ) * 289.0));
            vec3 tmpvar_33;
            tmpvar_33.xz = vec2(0.0, 1.0);
            tmpvar_33.y = tmpvar_30.y;
            vec3 x_34;
            x_34 = (tmpvar_32.y + tmpvar_33);
            vec3 x_35;
            x_35 = (((x_34 * 34.0) + 1.0) * x_34);
            vec3 tmpvar_36;
            tmpvar_36.xz = vec2(0.0, 1.0);
            tmpvar_36.y = tmpvar_30.x;
            vec3 x_37;
            x_37 = (((x_35 - 
                (floor((x_35 * 0.003460208)) * 289.0)
            ) + tmpvar_32.x) + tmpvar_36);
            vec3 x_38;
            x_38 = (((x_37 * 34.0) + 1.0) * x_37);
            vec3 tmpvar_39;
            tmpvar_39.x = dot (tmpvar_29, tmpvar_29);
            tmpvar_39.y = dot (x12_27.xy, x12_27.xy);
            tmpvar_39.z = dot (tmpvar_31.zw, tmpvar_31.zw);
            vec3 tmpvar_40;
            tmpvar_40 = max ((0.5 - tmpvar_39), 0.0);
            m_26 = (tmpvar_40 * tmpvar_40);
            m_26 = (m_26 * m_26);
            vec3 tmpvar_41;
            tmpvar_41 = ((2.0 * fract(
                ((x_38 - (floor(
                (x_38 * 0.003460208)
                ) * 289.0)) * vec3(0.02439024, 0.02439024, 0.02439024))
            )) - 1.0);
            vec3 tmpvar_42;
            tmpvar_42 = (abs(tmpvar_41) - 0.5);
            vec3 tmpvar_43;
            tmpvar_43 = (tmpvar_41 - floor((tmpvar_41 + 0.5)));
            m_26 = (m_26 * (1.792843 - (0.8537347 * 
                ((tmpvar_43 * tmpvar_43) + (tmpvar_42 * tmpvar_42))
            )));
            g_25.x = ((tmpvar_43.x * tmpvar_29.x) + (tmpvar_42.x * tmpvar_29.y));
            g_25.yz = ((tmpvar_43.yz * x12_27.xz) + (tmpvar_42.yz * x12_27.yw));
            float tmpvar_44;
            tmpvar_44 = (max (0.0, (
                (130.0 * dot (m_26, g_25))
            - 0.3)) * 1.428571);
            noise_1 = tmpvar_44;
            vec2 tmpvar_45;
            tmpvar_45.x = (tmpvar_23 * 10.0);
            tmpvar_45.y = (tmpvar_2.y * 2.4);
            vec3 g_46;
            vec3 m_47;
            vec4 x12_48;
            vec2 tmpvar_49;
            tmpvar_49 = floor((tmpvar_45 + dot (tmpvar_45, vec2(0.3660254, 0.3660254))));
            vec2 tmpvar_50;
            tmpvar_50 = ((tmpvar_45 - tmpvar_49) + dot (tmpvar_49, vec2(0.2113249, 0.2113249)));
            vec2 tmpvar_51;
            if ((tmpvar_50.x > tmpvar_50.y)) {
                tmpvar_51 = vec2(1.0, 0.0);
            } else {
                tmpvar_51 = vec2(0.0, 1.0);
            };
            vec4 tmpvar_52;
            tmpvar_52 = (tmpvar_50.xyxy + vec4(0.2113249, 0.2113249, -0.5773503, -0.5773503));
            x12_48.zw = tmpvar_52.zw;
            x12_48.xy = (tmpvar_52.xy - tmpvar_51);
            vec2 tmpvar_53;
            tmpvar_53 = (tmpvar_49 - (floor(
                (tmpvar_49 * 0.003460208)
            ) * 289.0));
            vec3 tmpvar_54;
            tmpvar_54.xz = vec2(0.0, 1.0);
            tmpvar_54.y = tmpvar_51.y;
            vec3 x_55;
            x_55 = (tmpvar_53.y + tmpvar_54);
            vec3 x_56;
            x_56 = (((x_55 * 34.0) + 1.0) * x_55);
            vec3 tmpvar_57;
            tmpvar_57.xz = vec2(0.0, 1.0);
            tmpvar_57.y = tmpvar_51.x;
            vec3 x_58;
            x_58 = (((x_56 - 
                (floor((x_56 * 0.003460208)) * 289.0)
            ) + tmpvar_53.x) + tmpvar_57);
            vec3 x_59;
            x_59 = (((x_58 * 34.0) + 1.0) * x_58);
            vec3 tmpvar_60;
            tmpvar_60.x = dot (tmpvar_50, tmpvar_50);
            tmpvar_60.y = dot (x12_48.xy, x12_48.xy);
            tmpvar_60.z = dot (tmpvar_52.zw, tmpvar_52.zw);
            vec3 tmpvar_61;
            tmpvar_61 = max ((0.5 - tmpvar_60), 0.0);
            m_47 = (tmpvar_61 * tmpvar_61);
            m_47 = (m_47 * m_47);
            vec3 tmpvar_62;
            tmpvar_62 = ((2.0 * fract(
                ((x_59 - (floor(
                (x_59 * 0.003460208)
                ) * 289.0)) * vec3(0.02439024, 0.02439024, 0.02439024))
            )) - 1.0);
            vec3 tmpvar_63;
            tmpvar_63 = (abs(tmpvar_62) - 0.5);
            vec3 tmpvar_64;
            tmpvar_64 = (tmpvar_62 - floor((tmpvar_62 + 0.5)));
            m_47 = (m_47 * (1.792843 - (0.8537347 * 
                ((tmpvar_64 * tmpvar_64) + (tmpvar_63 * tmpvar_63))
            )));
            g_46.x = ((tmpvar_64.x * tmpvar_50.x) + (tmpvar_63.x * tmpvar_50.y));
            g_46.yz = ((tmpvar_64.yz * x12_48.xz) + (tmpvar_63.yz * x12_48.yw));
            noise_1 = (tmpvar_44 + ((
                (130.0 * dot (m_47, g_46))
            - 0.5) * 0.15));
            float tmpvar_65;
            tmpvar_65 = (tmpvar_2.x - ((noise_1 * noise_1) * 0.25));
            if (isDad) {
                vec2 tmpvar_66;
                tmpvar_66.x = tmpvar_65;
                tmpvar_66.y = tmpvar_2.y;
                gl_FragColor = (gl_FragColor + flixel_texture2D (bitmap, tmpvar_66));
            };
            if (isDad) {
                gl_FragColor.xyz = (gl_FragColor.xyz + mix (gl_FragColor.xyz, vec3(fract(
                (sin(dot (vec2((tmpvar_2.y * tmpvar_23)), vec2(12.9898, 78.233))) * 43758.55)
                )), (noise_1 * 0.3)));
            };
            if (isDad) {
                float tmpvar_67;
                tmpvar_67 = floor((float(mod ((openfl_TextureCoordv.y * 0.3), 2.0))));
                if ((tmpvar_67 == 0.0)) {
                gl_FragColor.xyz = (gl_FragColor.xyz * (1.0 - (0.15 * noise_1)));
                };
            };
            if (isDad) {
                gl_FragColor = (gl_FragColor - ((flixel_texture2D (bitmap, tmpvar_2) + flixel_texture2D (bitmap, tmpvar_2)) + flixel_texture2D (bitmap, tmpvar_2)));
            };
            if (!(isDad)) {
                gl_FragColor = flixel_texture2D (bitmap, tmpvar_2);
            };
        }
    "
    )
    public function new()
    {
        super();
    }
}