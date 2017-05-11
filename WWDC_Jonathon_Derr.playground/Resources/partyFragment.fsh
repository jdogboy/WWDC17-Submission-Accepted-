void main() {
    
    vec4 f;
    vec2 g = gl_FragCoord.xy;
    g -= f.xy= vec2(u_width,u_height)/2.;
    
    g /= f.y;
    
    float d = pow(abs(0.5 - max(abs(g.x), abs(g.y))), 0.3);
    
    g += d;
    
    g *= g;
    
    f = vec4(g,d,0) * d * (2.6 + 0.4 * cos(75. * d+u_time*10.));
    
    gl_FragColor = mix(f, vec4(1.0,0.0,0.0,1.0), 0.5);
    

}
