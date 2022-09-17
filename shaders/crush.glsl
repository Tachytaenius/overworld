uniform vec2 inputCanvasSize;
uniform vec2 outputCanvasSize;
uniform vec2 crushCentre;
uniform float crushStart;
uniform float power;

vec4 sampleInputCanvas(sampler2D texture, vec2 fragmentPosition) {
	float fragmentDistance = distance(fragmentPosition, crushCentre);
	float crushedDistance = max(fragmentDistance, crushStart * pow(fragmentDistance / crushStart, power));
	vec2 crushedFragmentPosition = crushCentre + crushedDistance * normalize(fragmentPosition - crushCentre);
	return Texel(texture, crushedFragmentPosition / inputCanvasSize);
}

vec4 effect(vec4 colour, sampler2D texture, vec2 textureCoords, vec2 windowCoords) {
	return colour * sampleInputCanvas(texture, windowCoords + outputCanvasSize / 2);
}
