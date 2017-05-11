void main(){
    vec2 pos = vec2((gl_FragCoord.y /200) - 0.93, (gl_FragCoord.x / 200) - 1.175);
    
    const float pi = 3.14159;
    const float n =u_vert;
    
    float radius = length(pos - .07)*5.0 - 1.8;
    float t = atan(pos.y, pos.x)/(pi);
    
    float color = 0.0;
    for (float i = 0.0; i < n; i++){
        color += 0.006/abs(1.5 *sin(10.0*pi*(t + i/n*(u_time)*(u_speed/25) )) - radius);
    }
    
    gl_FragColor = vec4(vec3(red + 0.4,green + 0.4, blue+ 0.4) * color, color);
}
