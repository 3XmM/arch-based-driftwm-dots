#version 450

layout(location = 0) out vec4 f_color;

layout(push_constant) uniform Uniforms {
    vec2 u_resolution;
    vec2 u_camera;
    float u_zoom;
    float u_time;
};

void main() {
    // Получаем базовые координаты пикселя экрана
    vec2 uv = gl_FragCoord.xy / u_resolution;
    
    // Переворачиваем ось для Wayland
    uv.y = 1.0 - uv.y;

    // Киберпанк-палитра (Верх — бордовый, низ — темно-фиолетовый)
    vec3 topColor = vec3(0.18, 0.02, 0.05);    // Бордо (#2E050B)
    vec3 bottomColor = vec3(0.04, 0.01, 0.06); // Глубокий фиолетовый (#0A020F)

    // Смешиваем их строго по экрану (без u_camera и u_zoom)
    vec3 finalColor = mix(bottomColor, topColor, uv.y);

    // Добавляем микро-затемнение по углам экрана (виньетка)
    float vignette = uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y);
    vignette = clamp(pow(16.0 * vignette, 0.25), 0.0, 1.0);

    // Выводим результат
    f_color = vec4(finalColor * vignette, 1.0);
}
