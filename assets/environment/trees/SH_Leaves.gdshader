shader_type spatial;
render_mode cull_disabled, depth_prepass_alpha;

uniform vec4 color_dark : source_color = vec4(0.0692, 0.266, 0.0006, 1.0);
uniform vec4 color_light : source_color = vec4(0.0339, 0.193, 0.0202, 1.0);
uniform sampler2D opacity_texture : hint_default_black, filter_linear_mipmap;

vec3 hue_shift(vec3 color, float shift) {
    vec3 k = vec3(0.57735, 0.57735, 0.57735);
    float cos_angle = cos(shift);
    return color * cos_angle + cross(k, color) * sin(shift) + k * dot(k, color) * (1.0 - cos_angle);
}

void fragment() {
	// 1. FRESNEL & VERTEX NORMAL WS
	// Dans Godot, NORMAL est dans l'espace vue par défaut dans le fragment.
	// Pour l'effet Fresnel basé sur la vue :
	float fresnel = 1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0);
	// Application de l'exposant (ici 1.0 donc pas de changement via un nœud Power)
	float fresnel_saturate = clamp(fresnel, 0.0, 1.0);
	
	// Multiplication par la couleur sombre et le facteur 0.1
	vec3 fresnel_color = fresnel_saturate * color_dark.rgb * 0.1;
	
	// 2. LOGIQUE BASÉE SUR LES NORMALES (Break Float3, Add, Multiply, Power, 1-x)
	// Recréation exacte de la chaîne du bas liée à l'alpha du Lerp
	float vertex_normal_y = NORMAL.y; // Équivalent du canal G (Y) de la normale
	float chain_math = vertex_normal_y + 1.0;
	chain_math = chain_math * 1.0;
	chain_math = pow(chain_math, 1.0);
	float lerp_alpha = 1.0 - chain_math;
	
	// 3. HUE SHIFT & LERP (Partie haute)
	// Simulation du nœud HueShift d'Unreal (Shift de 20.0 * 0.0 = 0.0 dans l'image d'origine)
	float shift_amount = 20.0 * 0.0; 
	vec3 shifted_color = hue_shift(color_light.rgb, shift_amount);
	
	// Équivalent du nœud Lerp entre la couleur de base et la couleur shiftée
	vec3 mix_color = mix(color_light.rgb, shifted_color, clamp(lerp_alpha, 0.0, 1.0));
	
	// 4. SORTIE ALBEDO & EMISSIVE
	// Addition de la couleur mixée et du résultat du Fresnel
	ALBEDO = mix_color + fresnel_color;
	
	// Propriétés de surface fixes de l'image
	METALLIC = 0.0;
	SPECULAR = 0.0;
	ROUGHNESS = 1.0;
	AO = 1.0;
	
	// 5. OPACITY MASK
	// Lecture du masque d'opacité (Texture Sample)
	vec4 tex_mask = texture(opacity_texture, UV);
	ALPHA = tex_mask.g; // Utilise le canal Vert (G) comme sur votre image Unreal
	ALPHA_SCISSOR_THRESHOLD = 0.5; // Seuil d'écrêtage standard pour le feuillage
	
	// 6. NORMAL (Gestion du TwoSidedSign)
	// Unreal utilise TwoSidedSign pour inverser la normale sur la face arrière.
	// Godot gère cela nativement avec FRONT_FACING.
	vec3 normal_blue = vec3(0.0, 0.01, 1.0);
	vec3 final_normal = normal_blue * (FRONT_FACING ? 1.0 : -1.0);
	NORMAL_MAP = final_normal;
}
