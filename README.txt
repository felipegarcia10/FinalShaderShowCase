SHADERS: FINAL ASSIGNMENT

PG29Felipe

this project contains four shaders:

1. Vertex Shader - Waves: Assets/Shaders/VertexShader/WavesShader
	Description: This shader emulates sea waves combining Sine and Cosine waves, the parameters for this shader are:
		- Water Color.
		- Wave Amplitude.
		- Wave Frequency.
		- Wave Speed.
		- Secondary Amplitude.
		- Secondary Frequency.
		- Secondary Speed.
		
	Usage: Apply the OceanWaves_Mat material to a plane.

2. Fragment Shader - XRay: Assets/Shaders/FragmentShader/XRayShader
	Description: This shader emulates an XRay effect to see through objects. the parameters for this shader are:
		- Main Color.
		- Rim Color.
		- Rim Power.
		- Transparency.
		- Scan Speed.
		- Scan Density.
		- Scan Strength
	Usage: Apply the XRay_Mat material to any object you want

3. Item Shader - Pulsing Outline: Assets/Shaders/ItemShader/PulsingOutlineShader
	Description: this shader uses the Fresnel effect for the outline and a Sine wave for the pulsing effect, the parameters for this shader are:
		- Main Color.
		- Outline Color.
		- Outline Power.
		- Pulse Speed.
		- Pulse Strength.
		- Glow Intensity
	Usage: apply the PulsingOutline_Mat material to any 3D object.

4. Environment Shader - Portal: Assets/Shaders/Environmentshader/PortalShader
	Description: this shader samples a Perlin noise texture to create a distortion for the portal effect, the parameters for this shader are:
		- Inner Color
		- Edge Color
		- Noise Texture
		- Swirl Strength
		- Swirl Speed
		- Edge Speed
		- Alpha
	Usage: Apply the Portal_Mat material to a plane, make sure the Noise Texture parameter references the PerlinNoise texture


