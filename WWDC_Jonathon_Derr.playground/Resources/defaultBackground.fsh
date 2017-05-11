void main() {
    
     float d = distance(vec2((u_width / 2.), (u_height / 2.)), gl_FragCoord.xy) * (1./u_width+0.11)*0.01;
    
    vec3 white1 = vec3(0.5,0.5,0.5);
    vec3 eightWhite1 = vec3(0.5,0.5,0.5);
    vec3 pink1 = vec3(0.41,0.41,0.91);
    vec3 blue1 = vec3(0.94,0.36,0.60);
    
    vec2 uv =  gl_FragCoord.xy / vec2(u_width,u_height).xy;
    
    
    vec3 color = mix(mix(white1, eightWhite1, uv.x),mix(pink1, blue1, uv.y),d);
    

    
        gl_FragColor = vec4(color, 1.);
}
