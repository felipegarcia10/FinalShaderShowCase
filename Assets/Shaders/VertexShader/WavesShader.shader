Shader "Custom/VertexShader"
{
    Properties
    {
        _Color ("Water Color", Color) = (0.1, 0.4, 0.8, 1)

        _WaveAmplitude ("Wave Amplitude", Float) = 0.5
        _WaveFrequency ("Wave Frequency", Float) = 2.0
        _WaveSpeed ("Wave Speed", Float) = 1.0

        _SecondaryAmplitude ("Secondary Amplitude", Float) = 0.2
        _SecondaryFrequency ("Secondary Frequency", Float) = 4.0
        _SecondarySpeed ("Secondary Speed", Float) = 1.5
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
                float3 worldPos : TEXCOORD0;
            };

            float4 _Color;

            float _WaveAmplitude;
            float _WaveFrequency;
            float _WaveSpeed;

            float _SecondaryAmplitude;
            float _SecondaryFrequency;
            float _SecondarySpeed;

            v2f vert(appdata v)
            {
                v2f o;

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                float t = _Time.y;

                // Primary wave
                float wave1 = sin(worldPos.x * _WaveFrequency + t * _WaveSpeed) * _WaveAmplitude;

                // Secondary wave
                float wave2 = cos(worldPos.z * _SecondaryFrequency + t * _SecondarySpeed) * _SecondaryAmplitude;

                // Combine waves
                float waveHeight = wave1 + wave2;

                // Apply displacement
                worldPos.y += waveHeight;

                o.pos = UnityWorldToClipPos(worldPos);

                o.worldPos = worldPos;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return _Color;
            }

            ENDCG
        }
    }
}
