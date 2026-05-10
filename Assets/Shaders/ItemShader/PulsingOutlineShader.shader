Shader "Custom/PulsingOutlineShader"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (0.2, 0.2, 0.2, 1)

        _OutlineColor ("Outline Color", Color) = (0.0, 1.0, 1.0, 1)

        _OutlinePower ("Outline Power", Float) = 4.0

        _PulseSpeed ("Pulse Speed", Float) = 2.0
        _PulseStrength ("Pulse Strength", Float) = 1.0

        _GlowIntensity ("Glow Intensity", Float) = 2.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
            };

            float4 _MainColor;
            float4 _OutlineColor;

            float _OutlinePower;

            float _PulseSpeed;
            float _PulseStrength;

            float _GlowIntensity;

            v2f vert(appdata v)
            {
                v2f o;

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                o.pos = UnityWorldToClipPos(worldPos);

                o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));

                o.viewDir = normalize(_WorldSpaceCameraPos - worldPos);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Fresnel outline
                float rim = 1.0 - saturate(dot(i.worldNormal, i.viewDir));

                rim = pow(rim, _OutlinePower);

                // Animated pulse
                float pulse = sin(_Time.y * _PulseSpeed) * 0.5 + 0.5;

                pulse *= _PulseStrength;

                // Final glow
                float glow = rim * pulse * _GlowIntensity;

                // Combine colors
                float3 finalColor = _MainColor.rgb + (_OutlineColor.rgb * glow);

                return float4(finalColor, 1.0);
            }

            ENDCG
        }
    }
}
