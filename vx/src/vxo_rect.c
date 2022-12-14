#include <stdarg.h>

#include "vx/vxo_rect.h"

#include "vx/vx_codes.h"
#include "vx/vx_global.h"


#include "vx/vxo_chain.h"
#include "vx/vxo_mesh.h"
#include "vx/vxo_points.h"
#include "vx/vxo_lines.h"
#include "vx/vxo_mat.h"


#define NVERTS 4
#define NIDX 6
static vx_resc_t * points = NULL;
static vx_resc_t * normals = NULL;
static vx_resc_t * indices = NULL;

static void vxo_rect_init()
{
    float verts_f[NVERTS*2] = {-0.5f,-0.5f,
                                0.5f,-0.5f,
                                0.5f, 0.5f,
                               -0.5f, 0.5f};
    uint32_t ind_i[NIDX] = {0,1,2,2,3,0};
    float norms_f[NVERTS*3] = {0,0,1,
                               0,0,1,
                               0,0,1,
                               0,0,1};


    points = vx_resc_copyf(verts_f, NVERTS*2);
    normals = vx_resc_copyf(norms_f, NVERTS*3);
    indices = vx_resc_copyui(ind_i, NIDX);

    vx_resc_inc_ref(points); // hold on to these references until vx_global_destroy()
    vx_resc_inc_ref(indices);
    vx_resc_inc_ref(normals);
}

// will run when the program vx_global_destroy() is called by user at end of program
static void vxo_rect_destroy(void * ignored)
{
    vx_resc_dec_destroy(points);
    vx_resc_dec_destroy(indices);
    vx_resc_dec_destroy(normals);
}

vx_object_t * _vxo_rect_private(vx_style_t * style, ...)
{
    // Make sure the static geometry is initialized safely, correctly, and quickly
    if (points == NULL) {
        pthread_mutex_lock(&vx_convenience_mutex);
        if (points == NULL) {
            vxo_rect_init();
            vx_global_register_destroy(vxo_rect_destroy, NULL);
        }
        pthread_mutex_unlock(&vx_convenience_mutex);
    }



    vx_object_t * vc = vxo_chain_create();
    va_list va;
    va_start(va, style);
    for (vx_style_t * sty = style; sty != NULL; sty = va_arg(va, vx_style_t *)) {

        switch(sty->type) {
            case VXO_POINTS_STYLE:
                vxo_chain_add(vc, vxo_points(points, NVERTS, sty));
                break;
            case VXO_LINES_STYLE:
                vxo_chain_add(vc, vxo_lines(points, NVERTS, GL_LINE_LOOP, sty));
                break;
            case VXO_MESH_STYLE:
                vxo_chain_add(vc, vxo_mesh_indexed(points, NVERTS, normals, indices, GL_TRIANGLES, sty));
                break;
        }
    }
    va_end(va);

    return vc;
}
