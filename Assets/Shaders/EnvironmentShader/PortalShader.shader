Shader "Custom/Portalshader"
{
    Properties
    {
        _MainColor ("Inner Color", Color) = (0.2, 0.6, 1.0, 1)
        _EdgeColor ("Edge Color", Color) = (0.8, 0.2, 1.0, 1)

        _NoiseTex ("Noise Texture", 2D) = "white" {}

        _SwirlStrength ("Swirl Strength", Float) = 2.0
        _SwirlSpeed ("Swirl Speed", Float) = 1.5

        _EdgePower ("Edge Power", Float) = 4.0
        _Alpha ("Alpha", Range(0,1)) = 0.9
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Off

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _NoiseTex;

            float4 _MainColor;
            float4 _EdgeColor;

            float _SwirlStrength;
            float _SwirlSpeed;
            float _EdgePower;
            float _Alpha;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;

                float3 worldPos =
                    mul(unity_ObjectToWorld, v.vertex).xyz;

                o.pos = UnityWorldToClipPos(worldPos);

                o.uv = v.uv;

                o.worldPos = worldPos;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float t = _Time.y * _SwirlSpeed;
                                
                float2 centeredUV = (i.uv - 0.5) * 2.0;

                float r = length(centeredUV);

                float angle = atan2(centeredUV.y, centeredUV.x);
                                
                float swirl = sin(r * 6.0 - t) * _SwirlStrength;

                angle += swirl;

                float2 warpedUV = float2(cos(angle),sin(angle)) * r * 0.5 + 0.5;

                // Noise distortion
                float noise =tex2D(_NoiseTex,warpedUV + t * 0.1).r;

                warpedUV += (noise - 0.5) * 0.1;
                
                float gradient = saturate(r + noise * 0.3);

                float3 color =lerp(_MainColor.rgb,_EdgeColor.rgb,pow(gradient, _EdgePower));

                return float4(color, _Alpha);
            }

            ENDCG
        }
    }
}
