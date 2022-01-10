uniform float z;
vec4 position(mat4 loveTransform, vec4 homogenVertexPosition) {
	homogenVertexPosition.z = z;
	return loveTransform * homogenVertexPosition;
}
