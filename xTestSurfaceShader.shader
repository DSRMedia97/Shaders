Shader "Custom/xTestSurfaceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
		//Tags tell Unity what order to call the shader 
        Tags { "RenderType"="Opaque" }
		//LOD = Level of Detail ~ method to manually call certain shader features depending on device
		//Couldn't find the documentation page
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
			//"Standard" is the lightModel ~ this one matches metallic workflow shader
			//"fullforwardshadows" is an additional directive for shadows ~ this supports all light shadow types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

		half SmoothWobble(half glossiness)
		{
			half t = (sin(glossiness) / 2.) + 0.5;
			return t;
		}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
			o.Smoothness = SmoothWobble(_Glossiness);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
