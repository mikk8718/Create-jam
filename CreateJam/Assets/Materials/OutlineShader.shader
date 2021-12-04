Shader "Custom/outlineShader"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        [PerRendererData] _Outline ("Outline", Float) = 0
        [PerRendererData] _OutlineColor ("Outline Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
            "PreviewType" = "Plane"
            "CanUseSpriteAtlas" = "True"
        }
        LOD 200


        Cull Off
        Lighting Off
        ZWrite Off
        Blend One OneMinusSrcAlpha

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma shader_feature ETC1_EXTERNAL_ALPHA
        #include "UnityCG.cginc"

        sampler2D _MainTex;

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float4 color : COLOR;
            float2 texcoord : TEXCORD0;
        };

        float _Outline;
        fixed4 _OutlineColor;

        v2f vert (appdata_base IN)
        {
            v2f OUT;
            OUT.vertex = UnityObjectToClipPos(IN.vertex);
            OUT.texcoord = IN.texcoord;

            return OUT;
        }

        fixed4 frag (v2f IN) : SV_Target
        {
            fixed4 c = SampleSpriteTexture(IN.texcoord) * IN.color;

            if(_Outline > 0 && c.a != 0)
            {
                fixed4 pixelUp = tex2D(_MainTex, IN.texcoord + fixed2(0, _MainTex_TexelSize.y));
                fixed4 pixelDown = tex2D(_MainTex, IN.texcoord - fixed2(0, _MainTex_TexelSize.y));
                fixed4 pixelLeft = tex2D(_MainTex, IN.texcoord - fixed2(_MainTex_TexelSize.x, 0));
                fixed4 pixelRight = tex2D(_MainTex, IN.texcoord + fixed2(_MainTex_TexelSize.x, 0));

                if(pixelUp.a * pixelDown.a * pixelLeft.a * pixelRight.a == 0)
                {
                    c.rgba = fixed4(1, 1, 1, 1) * _OutlineColor;
                }
            }

            c.rgb *= c.a;

            return c;
        }      
        ENDCG
    }
    FallBack "Diffuse"
}
