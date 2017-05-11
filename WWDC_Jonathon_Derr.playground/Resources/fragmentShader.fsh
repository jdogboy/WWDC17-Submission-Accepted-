
void main() {
    
    vec2 position = gl_FragCoord.xy / vec2(u_width,u_height).xy*2. - 1.;
    position.x *= u_width/u_height;
    
   float arctangent = atan(position.y,position.x);
    float _length = length(position);
    

    //Set color
    gl_FragColor = mix(vec4( cos((_length*u_zoom+sin(arctangent*u_vert)+arctangent-u_time* u_speed)) ), vec4(red,green,blue,1.0), 0.5);
 
}
