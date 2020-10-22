uniform sampler2D texture;
uniform sampler2D bgLayer;

varying vec4 vertTexCoord;

void main() {
    vec4 t = texture2D(texture, vertTexCoord.xy);
    vec4 c = vec4(0.0, 0.0, 0.0, 0.9);

    c *= (1.0 - t.a);

    gl_FragColor = c;
}