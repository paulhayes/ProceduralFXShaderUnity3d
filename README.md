# Reaction Diffusion Shader for Unity3d
Experiment in creating GPU calculated reaction diffusion systems.

Currently I'm experiencing a precision error in opengl. Despite using floating point render textures, and designating my shader output to float4, I'm still seeing very very low precision rounding errors. This is currently demonstrated in the main.scene using a simple FadeOut fragment, which iteratively multiplies the current colour by 99/100.

