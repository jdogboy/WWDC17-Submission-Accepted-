
void main() {
	vec3 top = vec3(0.0, 0., 1.);
    vec3 bottom = vec3(0.8, 0.1, 1.);
	gl_FragColor = vec4(top * (gl_FragCoord.y / u_height), 1) + vec4(bottom * (1.4 - (gl_FragCoord.y / u_height)),1);
}
