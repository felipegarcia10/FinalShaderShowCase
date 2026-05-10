Shader "Custom/XRayShader"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (0.0, 1.0, 1.0, 1.0)
        _RimColor ("Rim Color", Color) = (1.0, 1.0, 1.0, 1.0)

        _RimPower ("Rim Power", Float) = 4.0
        _Alpha ("Transparency", Range(0,1)) = 0.35

        _ScanLineSpeed ("Scan Speed", Float) = 2.0
        _ScanLineDensity ("Scan Density", Float) = 25.0
        _ScanLineStrength ("Scan Strength", Float) = 0.15
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
        Cull Back

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
                float3 worldPos : TEXCOORD2;
            };

            float4 _MainColor;
            float4 _RimColor;

            float _RimPower;
            float _Alpha;

            float _ScanLineSpeed;
            float _ScanLineDensity;
            float _ScanLineStrength;

            v2f vert(appdata v)
            {
                v2f o;

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);

                o.pos = UnityWorldToClipPos(worldPos);

                o.worldNormal = normalize(worldNormal);

                o.viewDir = normalize(_WorldSpaceCameraPos - worldPos);

                o.worldPos = worldPos;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Fresnel rim effect
                float rim = 1.0 - saturate(dot(i.worldNormal, i.viewDir));

                rim = pow(rim, _RimPower);

                // Animated scanlines
                float scan = sin(i.worldPos.y * _ScanLineDensity + _Time.y * _ScanLineSpeed);

                scan = scan * 0.5 + 0.5;

                // Combine effects
                float glow = rim + scan * _ScanLineStrength;

                float3 finalColor = _MainColor.rgb + (_RimColor.rgb * glow);

                return float4(finalColor, _Alpha + rim * 0.5);
            }

            ENDCG
        }
    }
}