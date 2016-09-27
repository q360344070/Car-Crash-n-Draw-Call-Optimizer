﻿Shader "Custom/Lambert" {
	Properties{
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader{
		Pass{
			Tags {
				"LightMode" = "ForwardBase"
			}
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			// user defined vars
			uniform float4 _Color;

			// Unity defined variables
			uniform float4 _LightColor0;

			// Structs
			struct vertexInput{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			struct vertexOutput{
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};

			// vertex function
			vertexOutput vert(vertexInput v){
				vertexOutput o;

				float3 normalDirection = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
				float3 lightDir;
				float atten = 1.0;

				lightDir = normalize(_WorldSpaceLightPos0.xyz);

				float3 diffuseReflection = atten * _LightColor0 * max( 0.0, dot(normalDirection, lightDir)) + UNITY_LIGHTMODEL_AMBIENT.xyz;

				o.col = float4(diffuseReflection * _Color.rgb, 1.0);
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				return o;
			}

			// fragment function
			float4 frag(vertexOutput i) : COLOR
			{
				return i.col;
			}

			ENDCG
		}
	}
	// Fallback "Diffuse"
}